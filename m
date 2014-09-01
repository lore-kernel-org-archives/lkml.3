Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbaIAOS2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:18:28 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:54217 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753398AbaIAOS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:18:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "'Lee Jones'" <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com,
        "'Tomasz Figa'" <t.figa@samsung.com>, broonie@kernel.org
Subject: Re: [PATCH] mfd: syscon: Decouple syscon interface from syscon devices
Date: Mon, 01 Sep 2014 16:18 +0200
Message-ID: <6929512.Xet4VLKWdC@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <000c01cfc5d9$03866c30$0a934490$@samsung.com>
References: <1408694991-21615-1-git-send-email-pankaj.dubey@samsung.com> <4121644.3haxjiIdIo@wuerfel> <000c01cfc5d9$03866c30$0a934490$@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:EFy3LSqE7Sz9zvX3cy0GGQKZmeUMX9FOforwXJdCaBm
 WTKFgdvpM/qML5IQxwKGTQMIVhePJLXLAoJx1T1TevQ1s7UiiO
 WSVYUfa5bNAJSXbqa9E9Fed1Egt7KFxFryOH1Cvi1jw6eMcCHC
 GFTUov2ZpEELFb5aHvjPBpxPmsKPWb418X6Y336tajx36QG75Q
 X+qeVpCx1Utc5btHu/vK415W/tN3HxyuaCzFXy9XdC/nU6upol
 2P8kbgVfalh/8SRWbVlYkUk4FeXUlwl/0REcHU2G+ZuC7BybN5
 EBhX15sliRZ1VRiNDRgzWpqMsD4FofOTl4r0mareB7dLJ7t+0e
 avXCEJRyB0MMD3jEDe4c=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 01 September 2014 17:05:33 Pankaj Dubey wrote:
> 
> Please have a look at this thread [1], where we discussed the need of syscon
> as platform device.
> Looks like still there are users of syscon_regmap_lookup_by_pdevname
> (clps711x.c).
> So we can't make it completely independent of platform_device. 
> 
> [1]
> https://www.mail-archive.com/linux-samsung-soc@vger.kernel.org/msg35708.html

I think the clps711x platform will soon stop using it, we already
have patches for migrating to DT.

	Arnd

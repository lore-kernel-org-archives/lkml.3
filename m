Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758500Ab3ANWYh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 17:24:37 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:52256 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757847Ab3ANWYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 17:24:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource allocation
Date: Mon, 14 Jan 2013 22:24:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com> <20130114161644.GC14721@kroah.com> <20130114221551.GA30020@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130114221551.GA30020@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301142224.11243.arnd@arndb.de>
X-Provags-ID: V02:K0:560sYHfWkzGxl9duWKixdNsUlE3pw6vEzWxRmXSHBNc
 biLASvLsG8MwxwDIROdHfYSjZumsSXwotoHaMf9OxWve7e9GvF
 DZaBHOOgLE1pNbXZmOeowAqbm2PA1kWX8OfvdW0gVCvunk3iN6
 ZxtmearN4XazJWRKqP2NBvRCJhyCRqWxcHooEuxD1RI1xvoCWq
 DesFismfDA9dP0U3zmPCWhvJuCmVso/JhhQ8Bpa0utfABFwQwa
 ttB/+P7t3hZodVHNXRpoySigNmnADO7YG3NeRyNX25S6fzdG/g
 rpOQlZcVcMK24suDRVzAlrqGKBvKcIU25p/iyzhJv1q7QqWLzk
 0ZlWdYd5kE0FK8dgNlcQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 January 2013, Thierry Reding wrote:
> It certainly sounds like a less complicated way to do it. But it also
> involves adding a function with a made up name and drop a function with
> a perfectly good name instead. I wouldn't even know what name to choose
> for the new API.
> 

How about devm_ioremap_resource()? Sounds equally fitting, and is shorter.

	Arnd

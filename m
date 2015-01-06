Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932431AbbAFTJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 14:09:08 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52711 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbAFTJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 14:09:06 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH v2 00/40] uaccess: fix sparse warning on get/put_user for bitwise types
Date: Tue, 06 Jan 2015 20:08:57 +0100
Message-ID: <4461163.Sc5FsMDTBa@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420558883-10131-1-git-send-email-mst@redhat.com>
References: <1420558883-10131-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:mL3cgrz3+dwmmGEsl8yOcVxwUDIgSaAfb4jgPHzw3EzgetrqYVn
 5bGsx7Ju3EzqG0A7eAzOS4L/w4AfG893At/2hxPD1IT3mDSPRHUzv/82GiMEeEm/b/CmPuE
 5zedZ5BsSk/dmuPIEVBp2eVlRSsgBaYa8tEgs8KWYojclYJ1w6pyaiw+w+KlGO/MjQkPv0Y
 ZuK/w2YJ57iaqK62Jpaeg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 06 January 2015 17:43:28 Michael S. Tsirkin wrote:
> 
> I tested this on x86 only. Since it's just adding __force, should be
> trivially safe everywhere?
> 
> 
> Arnd, did you merge v1 already? If yes, can you please replace with
> this version?
> 

I haven't merged it yet. I see that more Acks and some comments are
coming in. Once those are done, could you send a pull request? It
might be useful to have a branch that can be shared with architecture
trees if necessary to avoid merge conflicts.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaD2DPK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 23:15:10 -0400
Received: from mail-ob0-f172.google.com ([209.85.214.172]:58250 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaD2DPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 23:15:07 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1404291202190.32739@nippy.intranet>
References: <20140319123516.542623278@telegraphics.com.au>
	<1398532863.24466.2.camel@dabdike.int.hansenpartnership.com>
	<alpine.LNX.2.00.1404291202190.32739@nippy.intranet>
Date: Tue, 29 Apr 2014 15:15:05 +1200
Message-ID: <CAOmrzk+kuepC7QR4uchP_zxk7-Bi7faiF-Z5jGX9KMcHn-7_9Q@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] scsi/NCR5380: fix debugging macros and #include structure
From: Michael Schmitz <schmitzmic@gmail.com>
To: Finn Thain <fthain@telegraphics.com.au>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        scsi <linux-scsi@vger.kernel.org>, Sam Creasey <sammy@sammy.net>,
        Russell King <linux@arm.linux.org.uk>,
        Michael Schmitz <schmitz@debian.org>, Joe Perches <joe@perches.com>,
        Linux Kernel Development <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        "Linux/m68k" <linux-m68k@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finn,

On Tue, Apr 29, 2014 at 2:22 PM, Finn Thain <fthain@telegraphics.com.au> wrote:
>
> On Sat, 26 Apr 2014, James Bottomley wrote:
>
>> OK, so this is a pretty big change to an unmaintained driver.  I'll take
>> it if you're willing to maintain the driver afterwards ... in which case
>> I need another patch to add you to the MAINTAINERS file.
>
> Sure, I'm happy to support these patches and future work I plan to do on
> the driver.
>
> What additional responsibilities would come with adding my name the
> MAINTAINERS file?
>
> Perhaps Michael and Sam would be interested in sharing the role, for atari
> and sun3 NCR5380 drivers (?)

If you insist ...

(kidding - I"m OK with it if James thinks it's worth it)

Cheers,

  Michael

>
> I only have hardware to test mac_scsi but I can obtain a Domex DMX3191D
> PCI card on ebay.
>
> --

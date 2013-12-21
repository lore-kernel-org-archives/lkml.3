Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab3LUX5f (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 18:57:35 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:48945 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753738Ab3LUX5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 18:57:33 -0500
MIME-Version: 1.0
In-Reply-To: <CAAfyv36c8XktjUxpX0NQLh9vgBdr-FTKToamUT5ankzTZG_wJw@mail.gmail.com>
References: <CAAfyv36c8XktjUxpX0NQLh9vgBdr-FTKToamUT5ankzTZG_wJw@mail.gmail.com>
Date: Sun, 22 Dec 2013 00:57:31 +0100
Message-ID: <CAAfyv36uE6hgEYW6t9Zhmn6W1Zd6XCR9xz8vNNuxaL4XzXvCUQ@mail.gmail.com>
Subject: Re: 3.13 gta04 mmc not working
From: Belisko Marek <marek.belisko@gmail.com>
To: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

OK seems I found solution:
http://marc.info/?l=linux-omap&m=138756097116464&w=2
@Tony: Is this going to 3.13?

On Sun, Dec 22, 2013 at 12:26 AM, Belisko Marek <marek.belisko@gmail.com> wrote:
> Hi,
>
> I'm trying to boot gta04 board with DT with latest 3.13-rc4 kernel.
> Most of the parts seems to work except of mmc. I can see for mmc0 only
> messages (vmmc1  and vsim regulators seems to be fine):
> [    1.969573] VMMC1: 1850 <--> 3150 mV at 3000 mV
> [    2.016784] VSIM: 1800 <--> 3000 mV at 1800 mV
>
> [    2.399444] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
> [    2.749694] Waiting for root device /dev/mmcblk0p2...
> [    4.588562] mmc0: error -110 whilst initialising SD card
>
> Any ideas where to look or it is already know issue (not enough
> googling on my side?)
>
> Thanks,
>
> marek
>
> --
> as simple and primitive as possible
> -------------------------------------------------
> Marek Belisko - OPEN-NANDRA
> Freelance Developer
>
> Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
> Tel: +421 915 052 184
> skype: marekwhite
> twitter: #opennandra
> web: http://open-nandra.com

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com

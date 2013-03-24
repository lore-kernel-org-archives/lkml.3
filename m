Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3CXUUs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 16:20:48 -0400
Received: from queueout02-winn.ispmail.ntl.com ([81.103.221.56]:61817 "EHLO
	queueout02-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab3CXUUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 16:20:46 -0400
Message-ID: <514F53F3.1020303@blueyonder.co.uk>
Date: Sun, 24 Mar 2013 19:28:51 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: LKML Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 3.9-rc4 Makefile EXTRAVERSION still -rc3
References: <514EFC08.1000509@blueyonder.co.uk> <CAMuHMdXyn+rCkBJg29CFW-kzCM+AbvhsEVfNueXXfyFs8FFqtg@mail.gmail.com> <514F1D9E.8020601@blueyonder.co.uk> <CAMuHMdVYKdasvv8aNqA1DWj-T3GAHPwTnBZOA5utrP5MwX9gBw@mail.gmail.com>
In-Reply-To: <CAMuHMdVYKdasvv8aNqA1DWj-T3GAHPwTnBZOA5utrP5MwX9gBw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Cloudmark-Analysis: v=1.1 cv=AUhbpHVS+xhHrj9wLCYAQoYnFLYUZdbP8UM0GmH2jwk= c=1 sm=0 a=8gK0viZu5AQA:10 a=KIrl3I8d7sUA:10 a=3NElcqgl2aoA:10 a=k1j_C7plYBUA:10 a=8nJEP1OIZ-IA:10 a=a5Gf7U6LAAAA:8 a=tBb2bbeoAAAA:8 a=NEAV23lmAAAA:8 a=Hbh1iZQfwfmQriIh-GcA:9 a=wPNLvfGTeEIA:10 a=yHIqe9kG5mgA:10 a=YuKU6ANggZ8A:10 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/03/13 15:45, Geert Uytterhoeven wrote:
> On Sun, Mar 24, 2013 at 4:37 PM, Sid Boyce <sboyce@blueyonder.co.uk> wrote:
>> tindog:/usr/src/XXX/linux # git pull
>> Already up-to-date.
>> tindog:/usr/src/XXX/linux # git show v3.9-rc4
>> fatal: ambiguous argument 'v3.9-rc4': unknown revision or path not in the
>> working tree.
> So you didn't have v3.9-rc4 yet. Probably the mirror was not up-to-date.
>
> Gr{oetje,eeting}s,
>
>                          Geert
>
> --
> Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org
>
> In personal conversations with technical people, I call myself a hacker. But
> when I'm talking to journalists I just say "programmer" or something like that.
>                                  -- Linus Torvalds
>
Just this minute when I tried it is now 3.9.0-rc4 but the strange thing 
is that it didn't say it was changing from rc3 to rc4 on any box, it 
silently changed Makefile.
remote: Counting objects: 266, done.
remote: Compressing objects: 100% (36/36), done.
remote: Total 175 (delta 142), reused 172 (delta 139)
Receiving objects: 100% (175/175), 32.92 KiB, done.
Resolving deltas: 100% (142/142), completed with 52 local objects.
 From https://github.com/torvalds/linux
    c8c1f16..3912a67  master     -> origin/master
Updating c8c1f16..3912a67
Fast-forward
  Makefile                                 |   2 +-
  arch/tile/configs/tilegx_defconfig       |   1 -
  arch/tile/configs/tilepro_defconfig      |   1 -
  arch/x86/kernel/microcode_intel_early.c  |  30 
+++++++++++++++---------------
  arch/x86/lib/usercopy_64.c               |   4 ++--
  drivers/firmware/Kconfig                 |  18 ++++++++++++++++++
  drivers/firmware/efivars.c               | 150 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++----------------------------------------------
  drivers/gpio/gpiolib-of.c                |   5 ++---
  drivers/md/md.c                          |   6 ++----
  drivers/md/md.h                          |   4 ++--
  drivers/md/raid5.c                       | 116 
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----------------------------------
  drivers/md/raid5.h                       |   5 +----
  drivers/pinctrl/mvebu/pinctrl-mvebu.c    |   2 +-
  drivers/pinctrl/pinconf.c                |   2 +-
  drivers/pinctrl/pinconf.h                |   2 +-
  drivers/pinctrl/pinctrl-abx500.c         |   2 +-
  drivers/pinctrl/pinmux.c                 |   5 +++++
  drivers/target/iscsi/iscsi_target_auth.c |   5 ++++-
  drivers/target/target_core_file.h        |   2 +-
  drivers/target/target_core_pscsi.c       |  11 ++++++++---
  drivers/target/target_core_sbc.c         |   7 +++++--
  drivers/target/target_core_tpg.c         |   3 ++-
  drivers/vhost/tcm_vhost.c                |  13 +++++++++----
  23 files changed, 266 insertions(+), 130 deletions(-)
tindog:/usr/src/XXX/linux # o Makefile
VERSION = 3
PATCHLEVEL = 9
SUBLEVEL = 0
EXTRAVERSION = -rc4
NAME = Unicycling Gorilla
Regards
Sid.

-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks


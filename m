Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172Ab3DXPi1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:38:27 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:39734 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab3DXPi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:38:26 -0400
From: Paul Moore <paul@paul-moore.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>,
        selinux@tycho.nsa.gov
Subject: Re: Build regressions/improvements in v3.9-rc8
Date: Wed, 24 Apr 2013 11:38:23 -0400
Message-ID: <11026580.BGB2mffbp5@sifl>
User-Agent: KMail/4.10.2 (Linux/3.8.5-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg>
References: <alpine.DEB.2.00.1304232131300.11127@ayla.of.borg>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 23, 2013 09:32:02 PM Geert Uytterhoeven wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.9-rc8[1] compared to v3.8[2].
> 
> Summarized:
>   - build errors: +19/-58
>   - build warnings: +223/-377
> 
> JFYI, when comparing v3.9-rc8 to v3.9-rc7[3], the summaries are:
>   - build errors: +9/-8
>   - build warnings: +96/-145
> 
> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.
> 
> As I haven't mastered kup yet, there's no verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.9-rc8.summa
> ry.gz
> 
> Happy fixing! ;-)
> 
> Thanks to the linux-next team for providing the build service.
> 
> [1] http://kisskb.ellerman.id.au/kisskb/head/6122/ (all 118 configs)
> [2] http://kisskb.ellerman.id.au/kisskb/head/5896/ (117 out of 118 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6094/ (all 118 configs)

...

> => 93:1 + security/selinux/netnode.c: warning: 'idx' may be used
> uninitialized in this function [-Wuninitialized]: 174:27 => 174:2, 174:27 +

FYI: A fix for this was (re)sent to the SELinux list on April 4th.

 * http://marc.info/?l=selinux&m=136508710131898&w=2

-- 
paul moore
www.paul-moore.com


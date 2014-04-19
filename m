Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbaDSTTa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2014 15:19:30 -0400
Received: from mail-yh0-f46.google.com ([209.85.213.46]:52851 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754991AbaDSTTY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2014 15:19:24 -0400
MIME-Version: 1.0
In-Reply-To: <108530.1397932407@turing-police.cc.vt.edu>
References: <CAGG-pURwpGGFyCp-htffegnVhf1VwAke1XPrC+GirXKy-HhqJA@mail.gmail.com>
	<20140419161552.GB27776@amd.pavel.ucw.cz>
	<CAGG-pUQ5+dv566KZK2hbQENXSEPaY5k5fapgnLUE0jTv1ihPMg@mail.gmail.com>
	<108530.1397932407@turing-police.cc.vt.edu>
Date: Sat, 19 Apr 2014 16:19:23 -0300
Message-ID: <CAGG-pURRQpRL2dTT5gmgqnuDtU048OL6xJHFc1W6KkugR6He3g@mail.gmail.com>
Subject: Re: [Kernel-BR] Re: [RFC] Only a.out QMAGIC format is working
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: kernel-br <kernel-br@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "open list:FILESYSTEMS (VFS...), linux-kernel@vger.kernel.org (open
	list)" <linux-fsdevel@vger.kernel.org>,
        kernelnewbies <Kernelnewbies@kernelnewbies.org>, jikos@jikos.cz
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Valdis,

2014-04-19 15:33 GMT-03:00  <Valdis.Kletnieks@vt.edu>:
> On Sat, 19 Apr 2014 13:37:27 -0300, Geyslan Gregório Bem said:
>
>> Maintainers, is there some chance to fix it or a.out is really doomed?
>
> Is there an actual use case for a.out on a modern kernel?

Maybe retrocompatibility.

>
> In other wods, is there any reason to really care if it's doomed, since
> it's been *years* since that worked?

Perhaps not, but why to continue patching the ia32_aout.c and
binfmt_aout.c if that format doesn't matter (and work) anymore? That's
was the reason that I asked if it is really doomed in linux.


-- 
Regards,

Geyslan G. Bem
hackingbits.com

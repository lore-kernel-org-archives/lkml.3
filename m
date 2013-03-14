Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756950Ab3CNOXl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:23:41 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:34901 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab3CNOXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:23:39 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYs0MG3L4ti8tmVpwynVMMWKEVYdiOr+EG2ad2Z9D7x7A@mail.gmail.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdbozpAVNb+7QLhiiinC+MMERvA=vNFP5kZiWLnsiv7dpg@mail.gmail.com>
 <CACxGe6shiqqACd6S1VTEkno993xB+E7y2cLi3HOw6yUH+Mbn7A@mail.gmail.com>
 <CACRpkdbXhV_4PwOzAaTKtRB4-vjBB5hp007EWdz_DiDjtBgv4g@mail.gmail.com>
 <CAAVeFuJQ_QFaKRv=_POR=8MAv07=C9bSfQN6dn5AcRROx4m9xw@mail.gmail.com> <CACRpkdYs0MG3L4ti8tmVpwynVMMWKEVYdiOr+EG2ad2Z9D7x7A@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 14 Mar 2013 23:23:18 +0900
Message-ID: <CAAVeFuKsMVnof8pO_M1ju3TezpzTF+0c4419ks5GrEsWmusNTA@mail.gmail.com>
Subject: Re: [RFC 00/17] Remove GENERIC_GPIO from architecture code
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Alexandre Courbot <acourbot@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ralf Baechle <ralf@linux-mips.org>, Jonas Bonn <jonas@southpole.se>,
        Josh Boyer <jwboyer@gmail.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Vitaly Bordug <vitb@kernel.crashing.org>,
        Marcelo Tosatti <marcelo@kvack.org>, Paul Mundt <lethal@linux-sh.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Chris Zankel <chris@zankel.net>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 11:14 PM, Linus Walleij
<linus.walleij@linaro.org> wrote:
> For submitting the pull request to Torvalds in the end you will need
> to create a signed tag. Do you have a signed GPG key? Else it's
> about time to create a key and start collecting signatures... then you
> can also get a repo at kernel.org in the future.

I have one or two signatures of kernel devs on my GPG key, but I
thought that maybe this set could be pulled by you or Grant once it
has undergone enough testing - it's not like I intend to push
regularly on this branch.

If I understand correctly the reason for having this in its own branch
is to be able remove it quickly would it attempt to screw the dog.

>> (sorry for being clueless) what's the procedure to add a new branch to
>> linux-next? Shall I write to Stephen Rothwell directly?
>
> Yes. Join the linux-next mailing list too.

Will do that, thanks. First of all let me send the relevant patches
again to blackfin and m68k and get some feedback from them, since they
are the most affected.

Alex.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757281Ab3CNOJS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:09:18 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:38163 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756910Ab3CNOJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:09:15 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdbXhV_4PwOzAaTKtRB4-vjBB5hp007EWdz_DiDjtBgv4g@mail.gmail.com>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <CACRpkdbozpAVNb+7QLhiiinC+MMERvA=vNFP5kZiWLnsiv7dpg@mail.gmail.com>
 <CACxGe6shiqqACd6S1VTEkno993xB+E7y2cLi3HOw6yUH+Mbn7A@mail.gmail.com> <CACRpkdbXhV_4PwOzAaTKtRB4-vjBB5hp007EWdz_DiDjtBgv4g@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Thu, 14 Mar 2013 23:08:55 +0900
Message-ID: <CAAVeFuJQ_QFaKRv=_POR=8MAv07=C9bSfQN6dn5AcRROx4m9xw@mail.gmail.com>
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

On Thu, Mar 14, 2013 at 3:01 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Mar 13, 2013 at 8:53 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>> On Wed, Mar 13, 2013 at 1:12 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>>> On Tue, Mar 12, 2013 at 11:12 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
>>>
>>>> This series makes sure the GENERIC_GPIO option can only be set through GPIOLIB
>>>> (and not by individual architectures), as a first step towards its removal.
>>>
>>> Nice!
>>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>>
>>> I bet something will break, anyway: no pain no gain.
>>
>> Since this is a pretty invasive patch series that touches a lot of
>> architectures, we should get it into a separate branch that can get
>> pulled into linux-next.
>
> Good point. Alexandre, do you have a git repo to attain this?

Would be reasonable indeed. I can publish the branch on Github, but
(sorry for being clueless) what's the procedure to add a new branch to
linux-next? Shall I write to Stephen Rothwell directly?

Alex.

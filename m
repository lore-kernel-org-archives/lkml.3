Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab3CLNXc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:23:32 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:53327 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3CLNXb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:23:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130312125524.GA13877@samfundet.no>
References: <1363083150-30964-1-git-send-email-acourbot@nvidia.com>
 <1363083150-30964-16-git-send-email-acourbot@nvidia.com> <20130312125524.GA13877@samfundet.no>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 12 Mar 2013 22:23:10 +0900
Message-ID: <CAAVeFuLHf_-dy_rAgpuYaT5GFk76+StvO6XEKxmMChRin3+AnQ@mail.gmail.com>
Subject: Re: [RFC 15/17] avr32: default GENERIC_GPIO to false
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Haavard Skinnemoen <hskinnemoen@gmail.com>,
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
        Alexandre Courbot <gnurou@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 9:55 PM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Tue 12 Mar 2013 19:12:28 +0900 or thereabout, Alexandre Courbot wrote:
>
> $(Subject) is wrong, you state avr32, but it is for blackfin.

Argh, apologies. That's very wrong, especially since blackfin is one
of the archs most affected by this. Thanks for catching this, I hope
the maintainers will notice it too.

Alex.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507AbaFRElP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:41:15 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60075 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751514AbaFRElO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:41:14 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53A1185E.6080707@roeck-us.net>
Date: Tue, 17 Jun 2014 21:41:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Michal Simek <monstr@monstr.eu>,
        sparclinux <sparclinux@vger.kernel.org>
Subject: Re: Build regressions/improvements in v3.16-rc1
References: <1403018163-25307-1-git-send-email-geert@linux-m68k.org> <CAMuHMdU2DTt0va67uSKqhhqbVORuY+xEs3uGZ21sKjahE_MSXg@mail.gmail.com>
In-Reply-To: <CAMuHMdU2DTt0va67uSKqhhqbVORuY+xEs3uGZ21sKjahE_MSXg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 08:23 AM, Geert Uytterhoeven wrote:
> On Tue, Jun 17, 2014 at 5:16 PM, Geert Uytterhoeven
> <geert@linux-m68k.org> wrote:
[...]
>
>>    + /scratch/kisskb/src/sound/soc/fsl/fsl_dma.c: error: invalid use of undefined type 'struct ccsr_ssi':  => 926:34, 927:34
>
> powerpc/mpc85xx_defconfig
>

Being fixed:
	http://patchwork.ozlabs.org/patch/358500/

Guenter


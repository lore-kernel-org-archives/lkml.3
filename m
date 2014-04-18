Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753486AbaDRQtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 12:49:05 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63727 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbaDRQtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 12:49:02 -0400
MIME-Version: 1.0
Date: Sat, 19 Apr 2014 00:49:01 +0800
X-Google-Sender-Auth: r6u9eQxXbuPiG_iJcwKu3wEQlzQ
Message-ID: <CAFiDJ5-fuzNVF_OyNs-ZYS_qheLSSt7R75CkK2eQCkfYcF_aOw@mail.gmail.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
From: Ley Foon Tan <lftan@altera.com>
To: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Ley Foon Tan <lftan@altera.com>, LeyFoon Tan <lftan.linux@gmail.com>,
        cltang@codesourcery.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I just found that 4 patches (03/28, 05/28,07/28 and 14/28) are missing
here, because the issue in Git v1.8.3.2. But, the cover letter is correct.
Do I need to resend the whole series (28 patches) or just the missing 4 patches?
Thanks.

Regards.

On Fri, Apr 18, 2014 at 8:26 PM, Ley Foon Tan <lftan@altera.com> wrote:
> This patchset adds the Linux kernel port for Nios II processor from Altera.
> The nios2 Linux port follows the guidance for new architecture ports using
> generic headers (including unistd.h).
>
> About Nios II Cores
> -------------------
> Nios II is a 32-bit embedded-processor architecture designed specifically for the
> Altera family of FPGAs.
> More information is available  at http://www.altera.com/devices/processor/nios2/ni2-index.html
>
> Instruction set and architecture overview documents can be found on the
> following page:
> http://www.altera.com/literature/lit-nio2.jsp
>
> Nios2 GCC port is in mainline and and will be in the FSF 4.9 release.
>
> These patches are also available on this branch:
> git://git.rocketboards.org/linux-socfpga-next.git  nios2-upstream
>
> Regards,
> Ley Foon
> --
> 1.8.3.2
>

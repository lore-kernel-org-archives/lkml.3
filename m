Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab3EMJp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 05:45:26 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:57821 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754482Ab3EMJpW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 05:45:22 -0400
Message-ID: <5190B62C.1070704@mev.co.uk>
Date: Mon, 13 May 2013 10:45:16 +0100
From: Ian Abbott <abbotti@mev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130410 Thunderbird/17.0.5
MIME-Version: 1.0
To: Peter Huewe <peterhuewe@gmx.de>
CC: Ian Abbott <ian.abbott@mev.co.uk>,
        Mori Hess <fmhess@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH] staging/comedi: Add VIRT_TO_BUS dependency to 'fix' build
 failure
References: <1368396039-9249-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1368396039-9249-1-git-send-email-peterhuewe@gmx.de>
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-05-12 23:00, Peter Huewe wrote:
> If the platform does not provide virt_to_bus the ni_labpc.c driver fails to
> compile.
> In order not to break these builds we have to add a depends on
> CONFIG_VIRT_TO_BUS to the affected drivers.
>
> Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

I'll submit an alternate patch that won't break compilation of 
ni_labpc.c and doesn't depend on CONFIG_VIRT_TO_BUS.

-- 
-=( Ian Abbott @ MEV Ltd.    E-mail: <abbotti@mev.co.uk>        )=-
-=( Tel: +44 (0)161 477 1898   FAX: +44 (0)161 718 3587         )=-

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHTOpd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 10:45:33 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:33658 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750916AbaHTOpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 10:45:31 -0400
MIME-Version: 1.0
In-Reply-To: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
References: <1408541963-20736-1-git-send-email-geert+renesas@glider.be>
Date: Wed, 20 Aug 2014 23:45:29 +0900
Message-ID: <CANqRtoSKs+fb=JuMMyOW=m5mET8araTjmNyVyF4kodqv5GA-9A@mail.gmail.com>
Subject: Re: [PATCH 0/2] Legacy SH_INTC cleanup
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Simon Horman <horms@verge.net.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

On Wed, Aug 20, 2014 at 10:39 PM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
>         Hi Simon, Magnus,
>
> This series cleans up some of the legacy SH_INTC support, which is only used
> on 32-bit SuperH and early ARM SH-Mobile (sh7372/sh73a).
>
> There are no dependencies between the two patches.
> The first one is destined for your sh-drivers-for-v3.18 branch, while the
> second one is meant for your cleanup-for-v3.18 branch.
>
> Geert Uytterhoeven (2):
>   sh: intc: Confine SH_INTC to platforms that need it
>   ARM: shmobile: Move legacy INTC definitions from irqs.h to intc.h

Thanks, looking great!

Acked-by: Magnus Damm <damm+renesas@opensource.se>

Cheers,

/ magnus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaARR4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jan 2014 12:56:41 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:48104 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbaARR4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jan 2014 12:56:31 -0500
Message-ID: <52DAC048.5050807@landley.net>
Date: Sat, 18 Jan 2014 11:56:24 -0600
From: Rob Landley <rob@landley.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: hongbo.zhang@freescale.com, linux-doc@vger.kernel.org
CC: linux-kernel@vger.kernel.org, "David S. Miller" <davem@redhat.com>,
        Richard Henderson <rth@cygnus.com>, Jakub Jelinek <jakub@redhat.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Arthur Kepner <akepner@sgi.com>, sumit.semwal@linaro.org,
        Vinod Koul <vinod.koul@intel.com>, Pierre Ossman <drzeus@drzeus.cx>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH resend 1/2] Documentation: move all DMA documentations
 into Documentaion/dma
References: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1389869405-10363-1-git-send-email-hongbo.zhang@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/14 04:50, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
>
> Since there are already seven DMA documentations under the top Documentation/,
> it is better to create one dedicated directory for them.
>
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>
> Cc: David S. Miller <davem@redhat.com>
> Cc: Richard Henderson <rth@cygnus.com>
> Cc: Jakub Jelinek <jakub@redhat.com>
> Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Arthur Kepner <akepner@sgi.com>
> Cc: sumit.semwal@linaro.org
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Pierre Ossman <drzeus@drzeus.cx>
> Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

If the DMA guys merge this before I do, I note that it needs a 00-INDEX 
file for the new directory. (Otherwise I can add that when I forward it.)

Acked-by: Rob Landley <rob@landley.net>

Rob

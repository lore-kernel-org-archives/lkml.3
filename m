Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968068AbaLLNoO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 08:44:14 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:48278 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967834AbaLLNoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 08:44:12 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Fri, 12 Dec 2014 14:44:06 +0100
From: Stefan Agner <stefan@agner.ch>
To: gregkh@linuxfoundation.org
Cc: jslaby@suse.cz, jingchang.lu@freescale.com, shawn.guo@linaro.org,
        linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] serial: =?UTF-8?Q?fsl=5Flpuart=3A=20fix=20various?=
 =?UTF-8?Q?=20DMA=20related=20issues?=
In-Reply-To: <1417134205-4400-1-git-send-email-stefan@agner.ch>
References: <1417134205-4400-1-git-send-email-stefan@agner.ch>
Message-ID: <677f2c62b6b6c1fe8e16cd38d5f20d47@agner.ch>
User-Agent: Roundcube Webmail/1.0.3
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Fri Dec 12 14:43:19 2014
X-DSPAM-Confidence: 0.9899
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 548af0f712812754969599
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any thoughts on this patchset? Would have hopped that it makes it into
3.19 as those are mostly fixes.

--
Stefan

On 2014-11-28 01:23, Stefan Agner wrote:
> Patch 1 and 3 are actual fixes, whereas 2 and 4 don't lead to issues
> in standard cases but are still worthwhile fixes.
> 
> Stefan Agner (4):
>   serial: fsl_lpuart: delete timer on shutdown
>   serial: fsl_lpuart: move DMA channel request to probe
>   serial: fsl_lpuart: avoid new transfer while DMA is running
>   serial: fsl_lpuart: update RX timer on successful DMA transfer
> 
>  drivers/tty/serial/fsl_lpuart.c | 110 +++++++++++++++++++---------------------
>  1 file changed, 52 insertions(+), 58 deletions(-)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3F2VtP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 17:49:15 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:47767 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901Ab3F2VtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 17:49:13 -0400
Message-ID: <51CF565C.1020309@cogentembedded.com>
Date: Sun, 30 Jun 2013 01:49:16 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: djbw@fb.com, vinod.koul@intel.com
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH] dma: add driver for R-Car HPB-DMAC
References: <201306300015.50713.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201306300015.50713.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/30/2013 12:15 AM, Sergei Shtylyov wrote:

    Oops, forgot to add the From: line. The patch is not mine, I've only 
modified it slightly. Will repost now...

> Add support for HPB-DMAC found in Renesas R-Car SoCs, using 'shdma-base' DMA
> driver framework.
>
> Based on the original patch by Phil Edworthy <phil.edworthy@renesas.com>.
>
> Signed-off-by: Max Filippov <max.filippov@cogentembedded.com>
> [Sergei: removed useless #include, sorted #include's, fixed HPB_DMA_TCR_MAX,
> fixed formats and removed line breaks in the dev_dbg() calls, rephrased and
> added IRQ # to the shdma_request_irq() failure message, added MODULE_AUTHOR(),
> fixed guard macro name in the header file, fixed #define ASYNCRSTR_ASRST20,
> added #define ASYNCRSTR_ASRST24, beautified some commets.]
> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

WBR, Sergei


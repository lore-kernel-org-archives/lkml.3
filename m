Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180AbaICT52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 15:57:28 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:62597 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932108AbaICT50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 15:57:26 -0400
Message-ID: <540772A1.8080101@cogentembedded.com>
Date: Wed, 03 Sep 2014 23:57:21 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: mturquette@linaro.org, linux-kernel@vger.kernel.org
CC: linux-sh@vger.kernel.org, vksavl@gmail.com
Subject: Re: [PATCH] clk-rcar-gen2: RCAN clock support
References: <201407310023.43605.sergei.shtylyov@cogentembedded.com>
In-Reply-To: <201407310023.43605.sergei.shtylyov@cogentembedded.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 07/31/2014 12:23 AM, Sergei Shtylyov wrote:

> Add RCAN clock support to the R-Car generation 2 CPG driver. This clock gets
> derived from the USB_EXTAL clock by dividing it by 6. The layout of RCANCKCR
> register is close to those of the clocks supported by the 'clk-div6'  driver
> but has no divider field, and so can't be supported by that driver...

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
> The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git' repo.

>   drivers/clk/shmobile/clk-rcar-gen2.c |   99 +++++++++++++++++++++++++++++++++++
>   1 file changed, 99 insertions(+)

    More than a months has passed, there hasn't been any feedback, patch 
hasn't been applied... what's wrong with it?

WBR, Sergei


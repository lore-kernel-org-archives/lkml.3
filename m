Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab3FDRL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:11:29 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:44402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785Ab3FDRLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 13:11:25 -0400
Message-ID: <51AE1FBB.1070806@codeaurora.org>
Date: Tue, 04 Jun 2013 10:11:23 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH RFC 3/3] clk: dt: binding for basic divider clock
References: <1370281990-15090-1-git-send-email-mturquette@linaro.org> <1370281990-15090-4-git-send-email-mturquette@linaro.org>
In-Reply-To: <1370281990-15090-4-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/13 10:53, Mike Turquette wrote:
> +Required properties:
> +- compatible : shall be "divider-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : link to phandle of parent clock
> +- reg : base address for register controlling adjustable divider
> +- mask : arbitrary bitmask for programming the adjustable divider
> +
> +Optional properties:
> +- clock-output-names : From common clock binding.
> +- table : array of integer pairs defining divisors & bitfield values
> +- shift : number of bits to shift the mask, defaults to 0 if not present
> +- index_one : valid divisor programming starts at 1, not zero
> +- index_power_of_two : valid divisor programming must be a power of two
> +- allow_zero : implies index_one, and programming zero results in
> +  divide-by-one

It's preferred that property names have dashes instead of underscores.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


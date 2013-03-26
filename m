Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932591Ab3CZTsv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 15:48:51 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:48314 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab3CZTst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 15:48:49 -0400
MIME-Version: 1.0
In-Reply-To: <1364326685-8545-1-git-send-email-mturquette@linaro.org>
References: <1364326685-8545-1-git-send-email-mturquette@linaro.org>
Date: Tue, 26 Mar 2013 16:48:48 -0300
Message-ID: <CAOMZO5DqArX_gC-n=qkgZQSKhr_7eBoFRgFTZP1He8KcuucbKA@mail.gmail.com>
Subject: Re: [PATCH] ARM: imx: replace width with mask for clk_busy_mux
From: Fabio Estevam <festevam@gmail.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: linux-kernel@vger.kernel.org, Peter De Schrijver <pdeschrijver@nvidia.com>,
        Shawn Guo <shawn.guo@linaro.org>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Tue, Mar 26, 2013 at 4:38 PM, Mike Turquette <mturquette@linaro.org> wrote:
> The recent addition of table-based parent lookups[1] in the common
> clk_mux implementation removed the width member of struct clk_mux and
> replaced it with an arbitrary mask.  This broke compilation for i.MX
> platforms using clk_busy_mux which builds upon the common clk_mux.
>
> Fixed by populating the mask member during clk_busy_mux registration
> instead of the now non-existent width member.
>
> [1] http://article.gmane.org/gmane.linux.ports.tegra/10028
>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Peter De Schrijver <pdeschrijver@nvidia.com>
> Signed-off-by: Mike Turquette <mturquette@linaro.org>

I sent the same fix earlier today:
http://permalink.gmane.org/gmane.linux.ports.arm.kernel/226143

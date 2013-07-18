Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965134Ab3GRVEs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 17:04:48 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:53763 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab3GRVEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 17:04:46 -0400
Message-ID: <51E8586C.7040808@codeaurora.org>
Date: Thu, 18 Jul 2013 14:04:44 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Grant Likely <grant.likely@linaro.org>
CC: linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        devicetree-discuss@lists.ozlabs.org, Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 0/5] clk: dt: bindings for mux, divider & gate clocks
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
In-Reply-To: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/13 23:14, Mike Turquette wrote:
> This series introduces binding definitions for common register-mapped
> clock multiplexer, divider and gate IP blocks along with the
> corresponding setup functions for matching DT data.  The bindings are
> similar to the struct definitions but please don't hold that against the
> binding: the struct definitions closely model the hardware register
> layout.

I know there was some discussion about clock bindings and how they
should and should not be done at Linaro Connect Europe last week. Can
someone in that discussion reply to the mailing list with what came out
of that? I only have second hand knowledge about the discussion so it
would be good for me and others to know what was discussed. I'm
especially curious because the arm soc update etherpad[1] says "DT
describes what HW is (location, type, attributes), not how HW works
(register descriptions, bitmasks, etc)." but these proposed generic
clock bindings are describing registers and bitmasks.

[1] http://pad.linaro.org/p/LCE13_ARM_SOC_Tree_Consolidation_Update

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation


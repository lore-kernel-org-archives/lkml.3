Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756235Ab3EVPw2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 11:52:28 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:39914 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755278Ab3EVPw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 11:52:26 -0400
Date: Wed, 22 May 2013 17:52:23 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: James Hogan <james.hogan@imgtec.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Chao Xie <xiechao.mail@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
        Emilio =?iso-8859-1?Q?L=F3pez?= <emilio@elopez.com.ar>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Joseph Lo <josephl@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Pawel Moll <pawel.moll@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>, spear-devel@list.st.com,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v4 4/5] clk: add CLK_SET_RATE_NO_REPARENT flag
Message-ID: <20130522155223.GC8595@lukather>
References: <1369056507-32521-1-git-send-email-james.hogan@imgtec.com>
 <1369056507-32521-5-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369056507-32521-5-git-send-email-james.hogan@imgtec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

On Mon, May 20, 2013 at 02:28:26PM +0100, James Hogan wrote:
> Add a CLK_SET_RATE_NO_REPARENT clock flag, which will prevent muxes
> being reparented during clk_set_rate.
> 
> To avoid breaking existing platforms, all callers of clk_register_mux()
> are adjusted to pass the new flag. Platform maintainers are encouraged
> to remove the flag if they wish to allow mux reparenting on set_rate.

For the sunxi part,
Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

-- 
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

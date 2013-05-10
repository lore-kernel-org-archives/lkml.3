Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab3EJKlQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:41:16 -0400
Received: from multi.imgtec.com ([194.200.65.239]:19586 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab3EJKlP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:41:15 -0400
Message-ID: <518CCEC6.5050507@imgtec.com>
Date: Fri, 10 May 2013 11:41:10 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Mike Turquette <mturquette@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] clk: add support for clock reparent on set_rate
References: <1366388904-13903-1-git-send-email-james.hogan@imgtec.com> <1366388904-13903-3-git-send-email-james.hogan@imgtec.com> <518C0097.50300@codeaurora.org>
In-Reply-To: <518C0097.50300@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_05_10_11_41_12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/13 21:01, Stephen Boyd wrote:
> I believe we'll need to update the check in __clk_init() to allow you to
> have either a .round_rate or a .determine_rate op if you have a
> .recalc_rate op. Right now it fails to register the clock and then
> oopses later on while setting up clock debugfs.
> 
> Here's a (probably whitespace damaged) patch for the first one.

Thanks, I'll incorporate that.

Cheers
James


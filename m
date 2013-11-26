Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab3KZACP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 19:02:15 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43439 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022Ab3KZACH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 19:02:07 -0500
Date: Tue, 26 Nov 2013 00:01:53 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Paul Walmsley <pwalmsley@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: clk: clk_round_rate() should return 0, not negative numbers,
	upon error
Message-ID: <20131126000153.GY16735@n2100.arm.linux.org.uk>
References: <alpine.DEB.2.02.1311251553080.23090@tamien>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1311251553080.23090@tamien>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 03:55:33PM -0800, Paul Walmsley wrote:
>
> Update the documentation for clk_round_rate() to state that it should
> return 0 rather than a negative error code when it encounters an
> error.  This describes how the common clock framework currently works;
> howeever, some clock code does not yet align to this.
>
> This change is to prepare for returning unsigned values from
> clk_round_rate().

You really ought to document why this is being changed here, to help
sell the change to parties who are not aware of the background.
Otherwise, it just looks like a gratuitous API change.

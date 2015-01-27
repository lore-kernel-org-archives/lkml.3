Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932759AbbA0Txr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 14:53:47 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:52736 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932541AbbA0Txq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 14:53:46 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Boyd <sboyd@codeaurora.org>,
        "Maxime Ripard" <maxime.ripard@free-electrons.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <54BEE5D6.2060707@codeaurora.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, linux-kernel@vger.kernel.org
References: <1421789023-3128-1-git-send-email-maxime.ripard@free-electrons.com>
 <54BEE5D6.2060707@codeaurora.org>
Message-ID: <20150127195332.22722.90434@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: Export phase functions
Date: Tue, 27 Jan 2015 11:53:32 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Boyd (2015-01-20 15:33:42)
> On 01/20/2015 01:23 PM, Maxime Ripard wrote:
> > The phase setter and getter were not exported until now, which was causing
> > build breakages when callers were compiled as module. Export these two
> > functions.
> >
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> > ---
> 
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

Applied to clk-next.

Regards,
Mike

> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> 

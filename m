Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaBZVL4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:11:56 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:38565 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752484AbaBZVLy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:11:54 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: Mike Turquette <mturquette@linaro.org>
User-Agent: alot/0.3.5
To: Tushar Behera <tushar.behera@linaro.org>, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org
References: <1392791076-28301-1-git-send-email-tushar.behera@linaro.org>
In-Reply-To: <1392791076-28301-1-git-send-email-tushar.behera@linaro.org>
Message-ID: <20140226211150.12081.99155@quantum>
Subject: Re: [PATCH V2 0/2] Add support for clocks in S5M8767
Date: Wed, 26 Feb 2014 13:11:50 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tushar Behera (2014-02-18 22:24:34)
> S5M8767 chip has 3 crystal oscillators which are operated in the same
> as the crystal oscillators in S2MPS11. Extend s2mps11-clk driver to
> support clocks in S5M8767.
> 
> The patches are rebased on top of next-20130218.

These changes look good to me. Will these get picked up as part of a
Samsung clk pull request or would you prefer that I pick them
individually?

Regards,
Mike

> 
> Tushar Behera (2):
>   clk: clk-s2mps11: Refactor for including support for other MFD clocks
>   clk: clk-s2mps11: Add support for clocks in S5M8767 MFD
> 
>  drivers/clk/Kconfig       |    6 ++++--
>  drivers/clk/clk-s2mps11.c |   25 +++++++++++++++++++++----
>  2 files changed, 25 insertions(+), 6 deletions(-)
> 
> -- 
> 1.7.9.5
> 

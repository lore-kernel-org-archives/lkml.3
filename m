Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757254Ab3EaT0h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 15:26:37 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:48304 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757210Ab3EaT01 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 15:26:27 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <acourbot@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <51A4CAF9.4000305@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
References: <1369536991-6111-1-git-send-email-acourbot@nvidia.com>
 <51A4CAF9.4000305@wwwdotorg.org>
Message-ID: <20130531192623.21525.89041@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH RESEND] ARM: tegra114: correctly output clk_32k
Date: Fri, 31 May 2013 12:26:23 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-05-28 08:19:21)
> On 05/25/2013 08:56 PM, Alexandre Courbot wrote:
> > Tegra has a blink timer register that allows to modulate the
> > clk_32k clock before outputting it. Since clk_32k is presented to the
> > kernel as a fixed clock, make sure this register does not tamper with
> > the clock frequency and that clk_32k is outputted as-is, similarly to
> > what is done on t20 and t30.
> 
> The patch subject here should be "clk: tegra:" rather than "ARM:
> tegra114". I assume Mike can fix this up when applying it.

I fixed it up.  Been fixing up lots of s/ARM/clk/ lately.

Regards,
Mike

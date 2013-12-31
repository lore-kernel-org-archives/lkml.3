Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab3LaTNu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 14:13:50 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:58247 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab3LaTNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 14:13:48 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Mark Brown <broonie@kernel.org>,
        "Tushar Behera" <tushar.behera@linaro.org>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <20131231160916.GG31886@sirena.org.uk>
Cc: "lkml" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-samsung-soc" <linux-samsung-soc@vger.kernel.org>,
        "Lee Jones" <lee.jones@linaro.org>,
        "Kgene Kim" <kgene.kim@samsung.com>,
        "Patch Tracking" <patches@linaro.org>
References: <1383202124-1775-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-1-git-send-email-tushar.behera@linaro.org>
 <1388053141-30085-2-git-send-email-tushar.behera@linaro.org>
 <20131229221723.12054.40917@quantum>
 <CAHbNUh0tJHXv52bA9hBDZMH0Pi+x9uC=LojcvgS=ONnCgEmVTA@mail.gmail.com>
 <20131231160916.GG31886@sirena.org.uk>
Message-ID: <20131231191342.12054.42268@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH RESEND 1/4] clk: clk-s2mps11: Refactor for including support for
 other MFD clocks
Date: Tue, 31 Dec 2013 11:13:42 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Mark Brown (2013-12-31 08:09:16)
> On Mon, Dec 30, 2013 at 09:33:50AM +0530, Tushar Behera wrote:
> 
> > Commit 1b1ccee1e821 "mfd: s2mps11: Fix build after regmap field rename
> > in sec-core.c" is also touching this file, which is in Mark's tree
> > right now. If I rebase
> 
> It's been in Linus' tree for a while now.

OK, so I merged the two patches into clk-next, then merged clk-next into
next-20131224 and the merge is super trivial to resolve. So I propose
that we just let it get resolved in linux-next the usual way.

Any objections? If not I'll take these two patches into clk-next.

Regards,
Mike

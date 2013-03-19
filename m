Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965039Ab3CSVhT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 17:37:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:57117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756801Ab3CSVhR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 17:37:17 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <513F79BA.7000608@wwwdotorg.org>
Cc: linux-tegra@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1363113747-6572-1-git-send-email-pdeschrijver@nvidia.com>
 <513F79BA.7000608@wwwdotorg.org>
Message-ID: <20130319213706.8663.87186@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH] clk: add table lookup to mux
Date: Tue, 19 Mar 2013 14:37:06 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-03-12 11:53:46)
> On 03/12/2013 12:42 PM, Peter De Schrijver wrote:
> > Add a table lookup feature to the mux clock. Also allow arbitrary masks
> > instead of the width. This will be used by some clocks on Tegra114. Also
> > adapt the tegra periph clk because it uses struct clk_mux directly.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> > 
> > --
> > Mike,
> > 
> > This is the same patch I posted before which implements a table lookup
> > feature for the mux clock. I squashed both the changes to clk-mux.c and
> > tegra/clk.h together in order to make the patch bisectable.
> 
> For the record in this thread, this is a dependency of the Tegra114
> clock driver. Can this patch be added to a stable branch in the clk or
> arm-soc trees, which I can merge before applying the Tegra114 clock
> driver? Thanks.

Yes.  I don't have an immutable branch today, but I will have one by
-rc4.  It will be named clk-for-3.10.

I have a pending question about the ugly width/mask issue, otherwise
I'll let you know when I take this patch into clk-next.

Regards,
Mike

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423003Ab3CVUZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 16:25:33 -0400
Received: from mail-da0-f45.google.com ([209.85.210.45]:59971 "EHLO
	mail-da0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422990Ab3CVUZa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 16:25:30 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <514C813E.1070603@wwwdotorg.org>
Cc: linux-arm-kernel@lists.infradead.org,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
References: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com>
 <514C813E.1070603@wwwdotorg.org>
Message-ID: <20130322202522.834.24639@quantum>
User-Agent: alot/0.3.3+
Subject: Re: [PATCH REPOST v2] clk: add table lookup to mux
Date: Fri, 22 Mar 2013 13:25:22 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-03-22 09:05:18)
> On 03/22/2013 06:07 AM, Peter De Schrijver wrote:
> > Add a table lookup feature to the mux clock. Also allow arbitrary masks
> > instead of the width. This will be used by some clocks on Tegra114. Also
> > adapt the tegra periph clk because it uses struct clk_mux directly.
> > 
> > Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>
> 
> Tested-by: Stephen Warren <swarren@nvidia.com>

Thanks for the patch.  Taken into clk-next.

Regards,
Mike

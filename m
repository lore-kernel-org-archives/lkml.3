Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756600Ab3LTCqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 21:46:17 -0500
Received: from mail-gg0-f176.google.com ([209.85.161.176]:40722 "EHLO
	mail-gg0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755938Ab3LTCqP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 21:46:15 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Stephen Warren <swarren@wwwdotorg.org>,
        "Peter De Schrijver" <pdeschrijver@nvidia.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <52B3478A.2030405@wwwdotorg.org>
Cc: "Prashant Gaikwad" <pgaikwad@nvidia.com>,
        "Thierry Reding" <thierry.reding@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1387469676-17693-1-git-send-email-pdeschrijver@nvidia.com>
 <52B3478A.2030405@wwwdotorg.org>
Message-ID: <20131220024609.18119.76686@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: tegra: Add missing Tegra20 fuse clks
Date: Thu, 19 Dec 2013 18:46:09 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stephen Warren (2013-12-19 11:22:50)
> On 12/19/2013 09:14 AM, Peter De Schrijver wrote:
> 
> A patch description would be nice.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> 
> I assume this is going through the clock tree, and there aren't any
> dependencies between this patch and the other series touching fuses that
> showed up today? (or the dependencies will be resolved by deferring
> dependant patches to 3.15...)
> 

Acked-by: Mike Turquette <mturquette@linaro.org>

Quick note: now that we're using pull requests for the Nvidia clock
patches I'll just Ack patches that look good to me and at some point
I'll expect that patch to wind up in a future pull request.

If you just want me to take the patch directly it is no problem but
please let me know explicitly.

Thanks!
Mike

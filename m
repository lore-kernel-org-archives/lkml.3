Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933781Ab3CVQFX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 12:05:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49967 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933516Ab3CVQFW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 12:05:22 -0400
Message-ID: <514C813E.1070603@wwwdotorg.org>
Date: Fri, 22 Mar 2013 10:05:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>,
        Prashant Gaikwad <pgaikwad@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH REPOST v2] clk: add table lookup to mux
References: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1363954078-29952-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2013 06:07 AM, Peter De Schrijver wrote:
> Add a table lookup feature to the mux clock. Also allow arbitrary masks
> instead of the width. This will be used by some clocks on Tegra114. Also
> adapt the tegra periph clk because it uses struct clk_mux directly.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Tested-by: Stephen Warren <swarren@nvidia.com>

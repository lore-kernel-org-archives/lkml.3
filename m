Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933520Ab3JOUbI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:31:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:57926 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759839Ab3JOUbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:31:05 -0400
Message-ID: <525DA606.1040902@wwwdotorg.org>
Date: Tue, 15 Oct 2013 14:31:02 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 0/7] Tegra124 clock support
References: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1381850098-12357-1-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 09:14 AM, Peter De Schrijver wrote:
> This series introduces support for the Tegra124 CAR clocks.                                                                                                    
> Based on '[PATCH v3 00/12] Introduce common infra for tegra clocks'                                                                                            

Again, this series looks reasonable, but I'll hold my ack until the
testing issues I reported are resolved.

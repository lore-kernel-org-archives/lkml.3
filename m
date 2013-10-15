Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759487Ab3JOPmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 11:42:52 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52075 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759272Ab3JOPmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 11:42:50 -0400
Message-ID: <525D6276.1030507@wwwdotorg.org>
Date: Tue, 15 Oct 2013 09:42:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>, mturquette@linaro.org
CC: pgaikwad@nvidia.com, thierry.reding@gmail.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org
Subject: Re: pull request for tegra clocks (resend with some CCs added this
 time)
References: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
In-Reply-To: <20131015153620.GA12721@tbergstrom-lnx.Nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/15/2013 09:36 AM, Peter De Schrijver wrote:
> The following changes since commit a0cf1abc25ac197dd97b857c0f6341066a8cb1cf:
> 
>   Add linux-next specific files for 20130927 (2013-09-27 18:48:50 +1000)
> 
> are available in the git repository at:
>   git://nv-tegra.nvidia.com/user/pdeschrijver/linux.git tegra-clk-patches-0

??? That won't merge into Mike's tree correctly. The pull request should
be based on a -rc or final release in the Linus tree, e.g. based on
v3.12-rc1. Otherwise, if Mike merges this, it will pull in all patches
from other subsystems that went into linux-next.

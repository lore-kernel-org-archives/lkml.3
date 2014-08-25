Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933118AbaHYRkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:40:09 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37992 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933017AbaHYRkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:40:08 -0400
Message-ID: <53FB7511.9090205@wwwdotorg.org>
Date: Mon, 25 Aug 2014 11:40:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, pdeschrijver@nvidia.com,
        pgaikwad@nvidia.com, mturquette@linaro.org, thierry.reding@gmail.com
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/8] Tegra124 EMC (external memory controller) support
References: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1405088313-20048-1-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/11/2014 08:18 AM, Mikko Perttunen wrote:
> Hi everyone,
>
> this series adds support for the EMC (external memory controller) clock
> in the Tegra124 system-on-chip. The series has been tested on Jetson TK1.
>
> The first two patches remove the old "emc_mux" and "emc" clocks from the
> clock tree and the device tree bindings. This is, of course, not backwards
> compatible, but as these clocks have never been useful for anything
> (apart from maybe reading the boot rate of the EMC clock). If this is still
> not acceptable, the second patch can be dropped.
...

Mikko, this series had some comments, especially on the DT binding 
(patch 5/8) and how the MC/EMC drivers interact. Is there an updated 
version of the series? Or, is the series replaced by Tomeu Vizoso's work?

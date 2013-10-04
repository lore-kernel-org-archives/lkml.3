Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3JDUzN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:55:13 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52247 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JDUzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:55:11 -0400
Message-ID: <524F2B2B.9020303@wwwdotorg.org>
Date: Fri, 04 Oct 2013 14:55:07 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>, broonie@kernel.org
CC: swarren@nvidia.com, linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Subject: Re: [PATCH] regulator: palmas: get regulators node from parent node
 only
References: <1380809197-7759-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1380809197-7759-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/2013 08:06 AM, Laxman Dewangan wrote:
> The device tree binding of Palmas regulator driver says as:
> 
> palmas_pmis {
> 	compatible = "ti,palmas-pmic";
> 	...
> 	regulators {
> 		...
> 	}
> };
> 
> In this "regulators" subnode is expected to be part of parent node, not
> the outside of parent node. Hence to get the regulator node, the correct
> call is of_get_child_by_name() rather than of_find_node_by_name() which
> actually searches the "regulators" node from the parent node to end of DTS
> file.

Reviewed-by: Stephen Warren <swarren@nvidia.com>

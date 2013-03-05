Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758229Ab3CESPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:15:44 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42668 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331Ab3CESPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:15:42 -0500
Message-ID: <5136364B.7000506@wwwdotorg.org>
Date: Tue, 05 Mar 2013 11:15:39 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Rhyland Klein <rklein@nvidia.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Samuel Ortiz <sameo@linux.intel.com>, Anton Vorontsov <cbou@mail.ru>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-tegra@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Laxman Dewangan <ldewangan@nvidia.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] power_supply: tps65090-charger: Add binding doc
References: <1362423709-29596-1-git-send-email-rklein@nvidia.com> <1362423709-29596-4-git-send-email-rklein@nvidia.com>
In-Reply-To: <1362423709-29596-4-git-send-email-rklein@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2013 12:01 PM, Rhyland Klein wrote:
> This change adds the binding documentation for the tps65090-charger.

> diff --git a/Documentation/devicetree/bindings/power_supply/tps65090.txt b/Documentation/devicetree/bindings/power_supply/tps65090.txt
...
> +Example:
> +
> +	tps65090@48 {
...
> +		regulators {
> +			...
> +		};
> 

The "regulators" node in the example isn't mentioned in the list of
properties/nodes that's above. What goes in there? You probably want to
include text similar to what I've quoted below from
Documentation/devicetree/bindings/regulator/tps6586x.txt:

> - regulators: A node that houses a sub-node for each regulator within the
>   device. Each sub-node is identified using the node's name (or the deprecated
>   regulator-compatible property if present), with valid values listed below.
>   The content of each sub-node is defined by the standard binding for
>   regulators; see regulator.txt.
>   sys, sm[0-2], ldo[0-9] and ldo_rtc


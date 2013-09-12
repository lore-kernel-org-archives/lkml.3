Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753793Ab3ILO60 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:58:26 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35055 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751770Ab3ILO6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:58:25 -0400
Message-ID: <5231D68D.3000200@wwwdotorg.org>
Date: Thu, 12 Sep 2013 08:58:21 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, broonie@kernel.org,
        lm-sensors@lm-sensors.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/3] of: add vendor prefix for GMT
References: <1378985061-28547-1-git-send-email-wni@nvidia.com> <1378985061-28547-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1378985061-28547-3-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2013 05:24 AM, Wei Ni wrote:
> Adding Global Mixed-mode Technology Inc. to the list
> of devicetree vendor prefixes.

> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt

> +gmt	Global Mixed-mode Technology Inc.

There's some opportunity for confusion here re: the GMT timezone, but
GMT seems to be what the company abbreviates itself to on their website,
so I guess this is reasonable.

Acked-by: Stephen Warren <swarren@nvidia.com>

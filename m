Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932174Ab3HGQEE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 12:04:04 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:35723 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab3HGQEC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 12:04:02 -0400
Message-ID: <52026FEE.9070003@wwwdotorg.org>
Date: Wed, 07 Aug 2013 10:03:58 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375858358-15070-1-git-send-email-wni@nvidia.com> <1375858358-15070-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1375858358-15070-3-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2013 12:52 AM, Wei Ni wrote:
> Enable thermal sensor nct1008 for t114 dalmore.

Wei, I assume this patch doesn't depend on any of the other LM90-related
patches you've sent; I can simply apply it right away?

Is the LM90 DT binding fully documented somewhere, including the
vdd-supply property?

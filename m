Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966047Ab3HHRgF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 13:36:05 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45750 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965963Ab3HHRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:36:03 -0400
Message-ID: <5203D6FF.1060000@wwwdotorg.org>
Date: Thu, 08 Aug 2013 11:35:59 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Wei Ni <wni@nvidia.com>
CC: khali@linux-fr.org, linux@roeck-us.net, MLongnecker@nvidia.com,
        linux-arm-kernel@lists.infradead.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH v2 2/3] ARM: dt: t114 dalmore: add dt entry for nct1008
References: <1375944991-29182-1-git-send-email-wni@nvidia.com> <1375944991-29182-3-git-send-email-wni@nvidia.com>
In-Reply-To: <1375944991-29182-3-git-send-email-wni@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2013 12:56 AM, Wei Ni wrote:
> Enable thermal sensor nct1008 for t114 dalmore.

It'd be best to remove this patch from the series; send one series to
the LM90 maintainer with just the driver and DT binding changes, and
another series to the Tegra maintainer with the *.dts changes. You can
tell me not to apply the *.dts changes until the driver/binding changes
are accepted (or just wait until they are before sending the patch).


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934768Ab3FSP3x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 11:29:53 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36765 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSP3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 11:29:51 -0400
Message-ID: <51C1CE6C.8050309@wwwdotorg.org>
Date: Wed, 19 Jun 2013 09:29:48 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Jonghwan Choi <jhbird.choi@samsung.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Jay Agarwal'" <jagarwal@nvidia.com>
Subject: Re: [PATCH 3.9-stable] ARM: tegra30: clocks: Fix pciex clock registration
References: <003501ce6c82$9be49440$d3adbcc0$%choi@samsung.com>
In-Reply-To: <003501ce6c82$9be49440$d3adbcc0$%choi@samsung.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2013 06:19 PM, Jonghwan Choi wrote:
> This patch looks like it should be in the 3.9-stable tree, should we apply
> it?

The PCIe driver doesn't work usefully in that release, so there's not
much point back-porting this fix; alone, it won't make PCIe work there.

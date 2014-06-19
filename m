Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758166AbaFSP7K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 11:59:10 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:60773 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567AbaFSP7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 11:59:06 -0400
Message-ID: <53A308C8.2070004@wwwdotorg.org>
Date: Thu, 19 Jun 2014 09:59:04 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH] ARM: tegra: TN7: relax some regulators
References: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1403164154-1362-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/19/2014 01:49 AM, Alexandre Courbot wrote:
> Remove the regulator-always-on property from some regulators that do not
> need it. On recent kernels fixed regulators which supply is always on
> fail registration.

That sounds like a bug in the regulator core, which should be fixed there.

After all, we can fix *new* DTs to work around that behaviour change,
but old DTs are supposed to work with new kernels. Fixing this in the DT
doesn't help that.

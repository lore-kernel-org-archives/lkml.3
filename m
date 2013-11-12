Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab3KLU0r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 15:26:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:35445 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753301Ab3KLU0l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 15:26:41 -0500
Message-ID: <52828EF5.6090909@wwwdotorg.org>
Date: Tue, 12 Nov 2013 13:26:29 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>,
        Russell King <linux@arm.linux.org.uk>,
        Tomasz Figa <t.figa@samsung.com>
CC: Olof Johansson <olof@lixom.net>, Dave Martin <Dave.Martin@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v10 0/7] ARM: support for Trusted Foundations secure monitor
References: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1383819106-1400-1-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 03:11 AM, Alexandre Courbot wrote:
> Just a set of small fixes to address the concerns expressed on v9 with the
> non-prefixed version DT properties. I hope there won't be a need for an
> eleventh (!) version. :P

BTW, this version looks fine to me. On IRC, Olof said it looked OK to
him. I'm just waiting to hear back from Olof/Russell whether I should
merge this through the Tegra tree, or whether the first 1-3 patches
should go through Russell's tree.

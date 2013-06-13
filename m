Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758805Ab3FMTVl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:21:41 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41070 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3FMTVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:21:40 -0400
Message-ID: <51BA1BBF.6050106@wwwdotorg.org>
Date: Thu, 13 Jun 2013 13:21:35 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexandre Courbot <acourbot@nvidia.com>
CC: Joseph Lo <josephl@nvidia.com>, Karan Jhavar <kjhavar@nvidia.com>,
        Varun Wadekar <vwadekar@nvidia.com>,
        Chris Johnson <CJohnson@nvidia.com>,
        Matthew Longnecker <MLongnecker@nvidia.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomasz Figa <tomasz.figa@gmail.com>, Dave Martin <Dave.Martin@arm.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, gnurou@gmail.com,
        devicetree-discuss@lists.ozlabs.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/3] ARM: tegra: split setting of CPU reset handler
References: <1371114745-24710-1-git-send-email-acourbot@nvidia.com> <1371114745-24710-3-git-send-email-acourbot@nvidia.com>
In-Reply-To: <1371114745-24710-3-git-send-email-acourbot@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2013 03:12 AM, Alexandre Courbot wrote:
> Not all Tegra devices need to set the CPU reset handler in the same way.

s/need/can/ ?

> In particular, devices using a TrustZone secure monitor cannot set the
> reset handler directly and need to do it through a firmware operation.
> 
> This patch separates the act of setting the reset handler from its
> preparation, so the former can be implemented in a different way.


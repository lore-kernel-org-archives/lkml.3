Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012AbaBESlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:41:01 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:34308 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbaBESkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:40:55 -0500
Message-ID: <52F285B1.7030802@wwwdotorg.org>
Date: Wed, 05 Feb 2014 11:40:49 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Joseph Lo <josephl@nvidia.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Danny Huang <dahuang@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>,
        Wei Yongjun <yongjun_wei@trendmicro.com.cn>,
        Will Deacon <will.deacon@arm.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Dave Martin <dave.martin@linaro.org>, Tomasz Figa <t.figa@samsung.com>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Dmitry Osipenko <digetx@gmail.com>, Wolfram Sang <wsa@the-dreams.de>
Subject: Re: [PATCH v3 2/6] ARM: tegra: Add chipid, revision and fuse init
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com> <1390952176-30402-3-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1390952176-30402-3-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 04:36 PM, Peter De Schrijver wrote:
> All fuse related functionality will move to a driver in the following patches.
> To prepare for this, export all the required functionality in a global header
> file and move all users of fuse.h to tegra-soc.h

The patch subject and description don't appear related to each-other.

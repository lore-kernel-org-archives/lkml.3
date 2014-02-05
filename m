Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaBESok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 13:44:40 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:40609 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaBESoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 13:44:38 -0500
Message-ID: <52F28692.1070404@wwwdotorg.org>
Date: Wed, 05 Feb 2014 11:44:34 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joseph Lo <josephl@nvidia.com>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Danny Huang <dahuang@nvidia.com>
Subject: Re: [PATCH v3 5/6] misc: enable fuse drivers
References: <1390952176-30402-1-git-send-email-pdeschrijver@nvidia.com> <1390952176-30402-6-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1390952176-30402-6-git-send-email-pdeschrijver@nvidia.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 04:36 PM, Peter De Schrijver wrote:
> Enable building the fuse drivers.

This isn't really about enabling them. It's about changing which Tegra
fuse driver is built. Perhaps rephrase this more as:

ARM: tegra: build fuse driver from drivers/misc instead

The Tegra fuse code has moved to drivers/misc/fuse/tegra. Enable the
building of that code, and disable the building of the old fuse code in
arch/arm/mach-tegra/.

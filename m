Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbaANRk3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 12:40:29 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:50596 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaANRk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 12:40:27 -0500
Message-ID: <52D57688.8070105@wwwdotorg.org>
Date: Tue, 14 Jan 2014 10:40:24 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>, linux-kernel@vger.kernel.org
CC: Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/amba: don't check resource with devm_ioremap_resource
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de> <1389700739-3696-2-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1389700739-3696-2-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 04:58 AM, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.

This looks fine. I expect to apply it for 3.15 after the 3.14 merge
window, unless it's urgent to get it into 3.14 for some reason?

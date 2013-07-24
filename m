Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750898Ab3GXBaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:30:23 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41265 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3GXBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:30:22 -0400
Message-ID: <51EF2E29.8070900@wwwdotorg.org>
Date: Tue, 23 Jul 2013 18:30:17 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH 08/27] drivers/iommu: don't check resource with devm_ioremap_resource
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-9-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1374602524-3398-9-git-send-email-wsa@the-dreams.de>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 11:01 AM, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
> 
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
> Please apply via the subsystem-tree.

You probably want to Cc the usual commiter (Joerg Roedel
<joro@8bytes.org>). I've done so here.

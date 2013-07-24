Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750962Ab3GXBc4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 21:32:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41679 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab3GXBcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 21:32:54 -0400
Message-ID: <51EF2EC4.20306@wwwdotorg.org>
Date: Tue, 23 Jul 2013 18:32:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Wolfram Sang <wsa@the-dreams.de>
CC: linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 10/27] drivers/memory: don't check resource with devm_ioremap_resource
References: <1374602524-3398-1-git-send-email-wsa@the-dreams.de> <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
In-Reply-To: <1374602524-3398-11-git-send-email-wsa@the-dreams.de>
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

Greg KH usually commits patches to thus tree. I Cc'd him here.

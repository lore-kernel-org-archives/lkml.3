Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab3H0V2k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 17:28:40 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58341 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab3H0V2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 17:28:37 -0400
Message-ID: <521D1A02.8020401@wwwdotorg.org>
Date: Tue, 27 Aug 2013 15:28:34 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Libo Chen <clbchenlibo.chen@huawei.com>
CC: balbi@ti.com, Greg KH <gregkh@linuxfoundation.org>,
        USB <linux-usb@vger.kernel.org>, linux-tegra@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3/4] usb: phy-tegra-usb: use platform_{get,set}_drvdata()
References: <521C5EF3.2090907@huawei.com>
In-Reply-To: <521C5EF3.2090907@huawei.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2013 02:10 AM, Libo Chen wrote:
> Use the wrapper functions for getting and setting the driver data using
> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
> so we can directly pass a struct platform_device.

Acked-by: Stephen Warren <swarren@nvidia.com>

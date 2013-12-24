Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757777Ab3LXBdS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 20:33:18 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54946 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab3LXBdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 20:33:16 -0500
Date: Mon, 23 Dec 2013 17:28:01 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lee.jones@linaro.org, dwmw2@infradead.org, mark.rutland@arm.com,
        rob@landley.net, ijc+devicetree@hellion.org.uk, swarren@nvidia.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 2/2] power: reset: as3722: add power-off driver
Message-ID: <20131224012801.GA10223@lizard>
References: <1387545840-2844-1-git-send-email-ldewangan@nvidia.com>
 <1387545840-2844-2-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1387545840-2844-2-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 06:54:00PM +0530, Laxman Dewangan wrote:
> ams AS3722 supports the power off functionality to turn off
> system.
> 
> Add power off driver for ams AS3722.
> 
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>
> Tested-by: Stephen Warren <swarren@nvidia.com>
> ---
> Changes from V1:
> - Just added tested by.

Both applied, thanks a lot!

Anton

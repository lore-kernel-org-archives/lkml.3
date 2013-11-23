Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756360Ab3KWVhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 16:37:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43558 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab3KWVhf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 16:37:35 -0500
Message-ID: <52911FFA.7030002@ti.com>
Date: Sat, 23 Nov 2013 16:36:58 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Taras Kondratiuk <taras.kondratiuk@linaro.org>
CC: <patches@linaro.org>, <linaro-networking@linaro.org>,
        <linaro-kernel@lists.linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: keystone: enable big endian support
References: <1384971859-7748-1-git-send-email-taras.kondratiuk@linaro.org>
In-Reply-To: <1384971859-7748-1-git-send-email-taras.kondratiuk@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 November 2013 01:24 PM, Taras Kondratiuk wrote:
> Keystone code is big endian compatible,
> so mark it as one that supports big endian.
> 
> Note this patch just allows to select Big endian build
> for ARCH_KEYSTONE, but it does not enable BE by default.
> 
> Signed-off-by: Taras Kondratiuk <taras.kondratiuk@linaro.org>
> ---
Applied.. Thanks for the patch



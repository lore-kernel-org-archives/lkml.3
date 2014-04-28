Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756897AbaD1VwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:52:15 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:58214 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754078AbaD1VwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:52:12 -0400
X-Auth-Info: BGy7gc7LmSClWmd/ZpcSv6eY72KqnpwlhLcDezUL5TA=
From: Marek Vasut <marex@denx.de>
To: Jason Cooper <jason@lakedaemon.net>
Subject: Re: [PATCH] staging: crypto: skein: depend upon CRYPTO
Date: Mon, 28 Apr 2014 23:38:19 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20140425151554.GB31117@localhost> <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
In-Reply-To: <1398444309-24672-1-git-send-email-jason@lakedaemon.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404282338.19758.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, April 25, 2014 at 06:45:09 PM, Jason Cooper wrote:
> Fengguang's randconfig kernel build tester discovered the following
> warnings:
> 
> warning: (CRYPTO_THREEFISH) selects CRYPTO_ALGAPI which has unmet direct
> dependencies (CRYPTO) warning: (DM_VERITY && CRYPTO_SKEIN) selects
> CRYPTO_HASH which has unmet direct dependencies (CRYPTO)
> 
> Fix this in the Kconfig by depending on CRYPTO.
> 
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Jason Cooper <jason@lakedaemon.net>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut

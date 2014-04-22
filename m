Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888AbaDVX7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:59:40 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:40545 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbaDVX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:59:06 -0400
X-Auth-Info: YvAYGI/lnlbIfUrUZLfWh+Jp4o8UV8aAZe0GBeoBZk0=
From: Marek Vasut <marex@denx.de>
To: Christian Engelmayer <cengelma@gmx.at>
Subject: Re: [PATCH 2/3] crypto: Fix potential leak in test_aead_speed() if crypto_alloc_aead() fails
Date: Wed, 23 Apr 2014 01:35:30 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20140421204439.7999f1c6@spike> <20140421204640.76380365@spike>
In-Reply-To: <20140421204640.76380365@spike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404230135.30918.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 at 08:46:40 PM, Christian Engelmayer wrote:
> Fix a potential memory leak in the error handling of test_aead_speed(). In
> case crypto_alloc_aead() fails, the function returns without going through
> the centralized cleanup path. Reported by Coverity - CID 1163870.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Looks OK to me, thanks.

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut

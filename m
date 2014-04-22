Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643AbaDVX7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 19:59:10 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:35086 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477AbaDVX7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 19:59:06 -0400
X-Auth-Info: YvAYGI/lnlbIfUrUZLfWh+Jp4o8UV8aAZe0GBeoBZk0=
From: Marek Vasut <marex@denx.de>
To: Christian Engelmayer <cengelma@gmx.at>
Subject: Re: [PATCH 3/3] crypto: Fix leak of struct aead_request in test_aead_speed()
Date: Wed, 23 Apr 2014 01:36:25 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.11.3; x86_64; ; )
Cc: tim.c.chen@linux.intel.com, herbert@gondor.apana.org.au,
        davem@davemloft.net, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20140421204439.7999f1c6@spike> <20140421204705.07cb8278@spike>
In-Reply-To: <20140421204705.07cb8278@spike>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201404230136.26053.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, April 21, 2014 at 08:47:05 PM, Christian Engelmayer wrote:
> Fix leakage of memory for struct aead_request that is allocated via
> aead_request_alloc() but not released via aead_request_free().
> Reported by Coverity - CID 1163869.
> 
> Signed-off-by: Christian Engelmayer <cengelma@gmx.at>

Reviewed-by: Marek Vasut <marex@denx.de>

Best regards,
Marek Vasut

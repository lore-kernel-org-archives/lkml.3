Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757963AbaDWTYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:24:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:24249 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754085AbaDWTYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:24:18 -0400
Date: Wed, 23 Apr 2014 22:23:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-crypto@vger.kernel.org, "security@kernel.org" <security@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] crypto_user: Fix out-of-bounds read
Message-ID: <20140423192345.GZ4963@mwanda>
References: <57bf4e51f05fad506a0d1638852a5233b359e1dc.1398194946.git.luto@amacapital.net>
 <20140423114039.GY4963@mwanda>
 <CALCETrXhY-XdAk_cUbQfVN2=2jx-6J3wX7DYMeAiML=VOhM+SA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXhY-XdAk_cUbQfVN2=2jx-6J3wX7DYMeAiML=VOhM+SA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 08:48:34AM -0700, Andy Lutomirski wrote:
> BUILD_BUG_ON(NLMSG_MIN_TYPE != CRYPTO_MSG_BASE) might be a better
> thing to add, then.

I don't have a strong opinion.

regards,
dan carpenter


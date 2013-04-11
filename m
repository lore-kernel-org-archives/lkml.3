Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937297Ab3DKDCV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 23:02:21 -0400
Received: from ozlabs.org ([203.10.76.45]:46806 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936130Ab3DKDCR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 23:02:17 -0400
Message-ID: <516627B7.1030206@ozlabs.org>
Date: Thu, 11 Apr 2013 13:02:15 +1000
From: Jeremy Kerr <jk@ozlabs.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: David Miller <davem@davemloft.net>, vyasevic@redhat.com,
        patchwork@lists.ozlabs.org, jhbird.choi@samsung.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.8-stable] net: count hw_addr syncs so that unsync works
 properly.
References: <000001ce364b$f1b178b0$d5146a10$%choi@samsung.com> <20130410.205401.1135160208998128324.davem@davemloft.net> <20130411125954.74150e5689d3f65365947755@canb.auug.org.au>
In-Reply-To: <20130411125954.74150e5689d3f65365947755@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

>>> This patch looks like it should be in the 3.8-stable tree, should we apply
>>> it?
>>
>> I queue up networking patches as needed and that queue is
>> visible at:
>>
>> http://patchwork.ozlabs.org/user/bundle/2566/?state=*
> 
> Actually, this bundle is not visible via that link.  It appears to be a
> public bundle and visible via
> http://patchwork.ozlabs.org/bundle/davem/stable/?state=* .  I have
> insider knowledge :-)

Perhaps for public bundles, I should make the private link automatically
redirect to the public one?

Cheers,


Jeremy


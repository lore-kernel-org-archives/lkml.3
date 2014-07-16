Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934350AbaGPOPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:15:19 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39840 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759463AbaGPOPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:15:16 -0400
Date: Wed, 16 Jul 2014 10:09:06 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Raphael Silva <rapphil@gmail.com>
Subject: Re: linux-next: build failure after merge of the wireless-next tree
Message-ID: <20140716140905.GE13555@tuxdriver.com>
References: <20140716132851.5b974707@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140716132851.5b974707@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 01:28:51PM +1000, Stephen Rothwell wrote:
> Hi John,
> 
> After merging the wireless-next tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/staging/rtl8723au/core/rtw_sta_mgt.c: In function 'rtw_free_stainfo23a':
> drivers/staging/rtl8723au/core/rtw_sta_mgt.c:254:27: error: expected expression before ';' token
>   pstapriv->asoc_sta_count-;
>                            ^
> 
> Caused by commit 3dd51964026e ("rtl8723au: Corrections in the coding
> style") (its always the cleanup patches that cause problems :-))
> Please unit test *all* patches.
> 
> I have used the wireless-next tree from next-20140715 for today.

I'm dropping that one -- merging it was accidental anyway.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.

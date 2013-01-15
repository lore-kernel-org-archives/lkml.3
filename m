Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915Ab3AOOgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 09:36:42 -0500
Received: from masquerade.micron.com ([137.201.242.130]:5408 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756345Ab3AOOgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 09:36:41 -0500
Message-ID: <50F568A3.3060602@micron.com>
Date: Tue, 15 Jan 2013 20:03:07 +0530
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Sam Bradshaw <sbradshaw@micron.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        Kent Overstreet <koverstreet@google.com>
Subject: Re: linux-next: manual merge of the akpm tree with the block tree
References: <20130114145816.397108bb0b1aec82e77d5a7a@canb.auug.org.au>
In-Reply-To: <20130114145816.397108bb0b1aec82e77d5a7a@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-19554.007
X-TM-AS-Result: No--3.193900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/14/2013 9:28 AM, Stephen Rothwell wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in
> drivers/block/mtip32xx/mtip32xx.c between commit 16c906e51c6f ("mtip32xx:
> Add workqueue and NUMA support") from the  tree and commit "mtip32xx:
> convert to batch completion" from the akpm tree.
> 
> I couldn't see how to fix up the conflicts, so I just dropped the akpm
> tree patch.
> 

I will fix this and send out the patch.

--
Regards,
Asai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756560Ab3KHAFa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 19:05:30 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:43625 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756503Ab3KHAFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 19:05:21 -0500
Message-ID: <527C2AA9.9040608@oracle.com>
Date: Thu, 07 Nov 2013 18:04:57 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Olof Johansson <olof@lixom.net>
Subject: Re: linux-next: manual merge of the block tree with the  tree
References: <20131101142026.10390b6e3f70de348770c137@canb.auug.org.au> <5273C473.5070803@kernel.dk> <20131102072252.88d2380fa392705b912dbfad@canb.auug.org.au> <52740EB1.2070901@kernel.dk> <527411DD.7050008@oracle.com> <527414DE.9090704@kernel.dk> <52756583.2030808@oracle.com> <527BE7FA.90904@oracle.com> <20131107192545.GA20624@moria.home.lan>
In-Reply-To: <20131107192545.GA20624@moria.home.lan>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 01:25 PM, Kent Overstreet wrote:
> On Thu, Nov 07, 2013 at 01:20:26PM -0600, Dave Kleikamp wrote:

>> I ended up replacing a call to bio_iovec_idx() with __bvec_iter_bvec()
>> since the former was removed. It's not very elegant, but it works. I'm
>> open to suggestions on a cleaner fix, but it can wait until one or both
>> of these trees is merged.
> 
> No, that's definitely wrong. Read Documentation/block/biovecs.txt - you
> need to use either the new bio_iovec() or bio_iovec() iter. I can do the
> conversion later today.

Stephen,
Can you please drop the aio-direct tree for the time being?

My stuff is not aligning very well with the immutable biovecs and Kent
has a different approach in mind. I'll be working with him on a
replacement that will hopefully be simpler.

Thanks,
Shaggy

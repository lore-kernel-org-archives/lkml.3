Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3HTTN5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:13:57 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:31052 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3HTTNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:13:55 -0400
Message-ID: <5213BFCB.3010503@oracle.com>
Date: Tue, 20 Aug 2013 14:13:15 -0500
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130806 Thunderbird/17.0.8
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
CC: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130820130056.GA9652@infradead.org>
In-Reply-To: <20130820130056.GA9652@infradead.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,
Would you be willing to pick up
git://github.com/kleikamp/linux-shaggy.git for-next
into linux-next?

There will be some unclean merges, and I can send you updated patches
created against your latest tree. I'm not exactly sure of your process
wrt cleaning up merges, but I guess they would help.

Thanks,
Shaggy

On 08/20/2013 08:00 AM, Christoph Hellwig wrote:
> As I've seen very few replies to this:  how do we ensure this gets
> picked up for the 3.12 merge window?  The series has been a reposted
> a few times without complaints or major changes, but the ball still
> doesn't seem to get rolling.
> 
> I'd really like to do some ecryptfs and scsi target work that is going
> to rely on this soon.
> 

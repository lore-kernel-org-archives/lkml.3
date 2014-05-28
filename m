Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778AbaE1Prs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:47:48 -0400
Received: from sabe.cs.wisc.edu ([128.105.6.20]:48833 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753831AbaE1Prr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:47:47 -0400
Message-ID: <538602BB.2080609@cs.wisc.edu>
Date: Wed, 28 May 2014 10:37:31 -0500
From: Mike Christie <michaelc@cs.wisc.edu>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130917 Thunderbird/17.0.9
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree
References: <20140519140614.GA12183@infradead.org> <20140520100343.31490551@canb.auug.org.au> <20140520053928.GA1751@infradead.org> <20140521094636.515289e8@canb.auug.org.au> <1400639101.2481.19.camel@dabdike> <20140528105429.GA20549@infradead.org>
In-Reply-To: <20140528105429.GA20549@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2014 05:54 AM, Christoph Hellwig wrote:
>       be2iscsi: Fix processing cqe for cxn whose endpoint is freed

I didn't look at your tree, but when this patch was posted on the list I
think it had a bug.

http://www.spinics.net/lists/linux-scsi/msg74191.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab3KUKMq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 05:12:46 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:41592 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042Ab3KUKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 05:12:43 -0500
Date: Thu, 21 Nov 2013 02:13:08 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>, linux-aio@kvack.org,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [GIT PULL] direct IO support for loop driver
Message-ID: <20131121101308.GC17871@kmo-pixel>
References: <528A648F.1030007@oracle.com>
 <CA+55aFyF-Za7B=1kVDodbn942hETsWixAHCsh_wBA1b6pnUigQ@mail.gmail.com>
 <20131121095837.GB18232@infradead.org>
 <20131121100609.GB17871@kmo-pixel>
 <20131121101138.GA1100@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121101138.GA1100@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 02:11:38AM -0800, Christoph Hellwig wrote:
> On Thu, Nov 21, 2013 at 02:06:09AM -0800, Kent Overstreet wrote:
> > Can you post those patches somewhere? If that's the end goal of this
> > patch series, we should be able to look at them too.
> 
> I've should have the target side back working soon as I started on it
> again about a week ago.

Broken code is fine, I just want to see the overall approach.

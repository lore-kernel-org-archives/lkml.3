Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758088Ab3JNV3O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 17:29:14 -0400
Received: from kanga.kvack.org ([205.233.56.17]:40137 "EHLO kanga.kvack.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757392Ab3JNV3L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 17:29:11 -0400
Date: Mon, 14 Oct 2013 17:29:10 -0400
From: Benjamin LaHaise <bcrl@kvack.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20131014212910.GA31920@kvack.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com> <20130821130231.GG13330@kvack.org> <20131014150701.GA21529@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131014150701.GA21529@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 14, 2013 at 08:07:01AM -0700, Christoph Hellwig wrote:
> Ben,
> 
> are you fine with the series now?  It's been in linux-next for a while
> and it would be really helpful to get it in for the avarious places
> trying to do in-kernel file aio without going through the page cache.

No, I am not okay with it.  The feedback I provided 2 months ago has yet to 
be addressed.

		-ben
-- 
"Thought is the essence of where you are now."

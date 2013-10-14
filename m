Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756736Ab3JNPHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 11:07:08 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41430 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015Ab3JNPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 11:07:06 -0400
Date: Mon, 14 Oct 2013 08:07:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>, linux-aio@kvack.org
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20131014150701.GA21529@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
 <20130821130231.GG13330@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821130231.GG13330@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

are you fine with the series now?  It's been in linux-next for a while
and it would be really helpful to get it in for the avarious places
trying to do in-kernel file aio without going through the page cache.


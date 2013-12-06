Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757807Ab3LFLOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:14:41 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:52288 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757377Ab3LFLOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:14:40 -0500
Date: Fri, 6 Dec 2013 03:14:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, hch@infradead.org, clm@fb.com,
        viro@zeniv.linux.org.uk, zab@redhat.com, shaggy@kernel.org
Subject: Re: [PATCH 07/11] iov_iter: Kill written arg to iov_iter_init()
Message-ID: <20131206111439.GC1427@infradead.org>
References: <1386108017-27964-1-git-send-email-kmo@daterainc.com>
 <1386108017-27964-8-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386108017-27964-8-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This looks like a sligh cleanup to me.  But please provide a good patch
description telling why you're doing it.

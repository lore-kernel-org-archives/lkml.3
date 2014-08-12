Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505AbaHLPcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 11:32:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:58985 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752981AbaHLPca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 11:32:30 -0400
Date: Tue, 12 Aug 2014 08:32:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@primarydata.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-nfs@vger.kernel.org
Subject: Re: [PATCH 0/5] locks: move most locks_release_private calls outside
 of i_lock
Message-ID: <20140812153229.GA15922@infradead.org>
References: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407854893-2698-1-git-send-email-jlayton@primarydata.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, I might be missing something here, but wouldn't it be better
to reference count the file_lock structure and grab a reference to
it where we currently call (__)locks_copy_lock?


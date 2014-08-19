Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750806AbaHSM1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 08:27:37 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57065 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaHSM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 08:27:34 -0400
Date: Tue, 19 Aug 2014 05:27:34 -0700
From: Christoph Hellwig <hch@infradead.org>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Theodore Tso <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH RFC 2/4] vfs: add revoke() helpers
Message-ID: <20140819122734.GA27198@infradead.org>
References: <1407869648-1449-1-git-send-email-dh.herrmann@gmail.com>
 <1407869648-1449-3-git-send-email-dh.herrmann@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407869648-1449-3-git-send-email-dh.herrmann@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK on anything bloating struct file more.  If you want to add something
new to it find a way to put it on diet first by removing existing
fields.


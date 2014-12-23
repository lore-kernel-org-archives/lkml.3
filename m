Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932245AbaLWKw3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 05:52:29 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46709 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755914AbaLWKwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 05:52:07 -0500
Date: Tue, 23 Dec 2014 02:52:06 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Dongsu Park <dongsu.park@profitbricks.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Kent Overstreet <kmo@daterainc.com>, Ming Lin <mlin@minggr.net>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [RFC PATCH 17/17] Documentation: update notes in biovecs about
 arbitrarily sized bios
Message-ID: <20141223105206.GF27600@infradead.org>
References: <cover.1419241597.git.dongsu.park@profitbricks.com>
 <a116a7da8f881f69dfcc2e40bda91533f1bb3c57.1419241597.git.dongsu.park@profitbricks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a116a7da8f881f69dfcc2e40bda91533f1bb3c57.1419241597.git.dongsu.park@profitbricks.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> + * As of 3.18, block layer is written based on merging biovecs. Its goal is

I don't think this is true..


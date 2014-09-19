Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572AbaISL0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:26:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59272 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524AbaISL0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:26:34 -0400
Date: Fri, 19 Sep 2014 04:26:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [RFC v2 5/5] Check for O_NONBLOCK in all read_iter instances
Message-ID: <20140919112633.GD4639@infradead.org>
References: <cover.1410983998.git.milosz@adfin.com>
 <5d2507ee57b30987a1bbd495dce565f4ef86fdef.1410983999.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d2507ee57b30987a1bbd495dce565f4ef86fdef.1410983999.git.milosz@adfin.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FYI, this should be folded into the previous patch.


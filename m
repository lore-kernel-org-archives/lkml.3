Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaJ0J6T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:58:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39637 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751492AbaJ0J6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:58:16 -0400
Date: Mon, 27 Oct 2014 02:58:12 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Milosz Tanski <milosz@adfin.com>
Cc: Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: Re: [PATCH 4/4] vfs: RWF_NONBLOCK flag for preadv2
Message-ID: <20141027095812.GB23416@infradead.org>
References: <cover.1413923420.git.milosz@adfin.com>
 <ba8d704a12c7ceffce610fc438a0af11a3422002.1413923420.git.milosz@adfin.com>
 <x49k33po42c.fsf@segfault.boston.devel.redhat.com>
 <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANP1eJE-gRPNc9xDpAYKHVzcwS+v3AwDb=Dm1CBa=sevSczqjg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 01:16:04PM -0400, Milosz Tanski wrote:
> Christoph, should I apply your last 3 patches to the end of this tree
> and send it along with the next submission?

Yes, please do.  Please make sure to take my fixed repost of the
"xfs: add RWF_NONBLOCK support" patch.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaFZGwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 02:52:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40283 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753317AbaFZGwO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 02:52:14 -0400
Date: Wed, 25 Jun 2014 23:52:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Greg KH <gregkh@linux-foundation.org>, Joe Perches <joe@perches.com>,
        Andy Whitcroft <apw@canonical.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626065211.GA10358@infradead.org>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
 <20140626035959.GE904@kroah.com>
 <20140626044327.GA1645@thin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140626044327.GA1645@thin>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 09:43:27PM -0700, Josh Triplett wrote:
> How would you feel about a patch that flagged long lines with a warning
> in patch mode, but not in file mode?

Just tell people to not send patches to just cleanup checkpath.pl
warnings in code they don't actually maintain or make large changes
to.  If that BS went away a lot of peoples life would be a lot easier.


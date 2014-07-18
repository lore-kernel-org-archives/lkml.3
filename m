Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762061AbaGROV0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:21:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52245 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761825AbaGROVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:21:24 -0400
Date: Fri, 18 Jul 2014 07:21:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Richard Weinberger <richard@nod.at>
Cc: Guenter Roeck <linux@roeck-us.net>, Borislav Petkov <bp@suse.de>,
        akpm@linux-foundation.org, apw@canonical.com, joe@perches.com,
        tytso@mit.edu, dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718142114.GA10475@infradead.org>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C8CCE1.4000105@roeck-us.net>
 <20140718082324.GA31270@pd.tnic>
 <53C92332.5010807@roeck-us.net>
 <53C92535.2010605@nod.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53C92535.2010605@nod.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 03:46:29PM +0200, Richard Weinberger wrote:
> As capable kernel hacker you can still use a command like:
> diff -urN /dev/null $file | ./scripts/checkpatch.pl -

Or he could just use the existing -f flag.  I really don't understand
why you're trying to educate people by taking their toy away.  They'll
find another one in no time anyway.


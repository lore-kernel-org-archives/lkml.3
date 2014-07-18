Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161039AbaGRO1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:27:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40703 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755944AbaGRO1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:27:40 -0400
Date: Fri, 18 Jul 2014 16:27:33 +0200
From: Borislav Petkov <bp@suse.de>
To: Christoph Hellwig <hch@infradead.org>
Cc: Richard Weinberger <richard@nod.at>, Guenter Roeck <linux@roeck-us.net>,
        akpm@linux-foundation.org, apw@canonical.com, joe@perches.com,
        tytso@mit.edu, dwalter@google.com, neilb@suse.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718142733.GD31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C8CCE1.4000105@roeck-us.net>
 <20140718082324.GA31270@pd.tnic>
 <53C92332.5010807@roeck-us.net>
 <53C92535.2010605@nod.at>
 <20140718142114.GA10475@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140718142114.GA10475@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:21:14AM -0700, Christoph Hellwig wrote:
> Or he could just use the existing -f flag.

If you mean the -f flag to checkpatch, he's removing them both.

> I really don't understand why you're trying to educate people by
> taking their toy away. They'll find another one in no time anyway.

Maybe we should stop accepting patches created from running
checkpatch...?

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

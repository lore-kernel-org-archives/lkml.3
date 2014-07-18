Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176AbaGROZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:25:08 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40640 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934455AbaGROZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:25:06 -0400
Date: Fri, 18 Jul 2014 16:24:59 +0200
From: Borislav Petkov <bp@suse.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, joe@perches.com, tytso@mit.edu, dwalter@google.com,
        bp@suse.de, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718142459.GC31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C92C86.2030408@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53C92C86.2030408@metafoo.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 04:17:42PM +0200, Lars-Peter Clausen wrote:
> --file is a in my opinion useful option and at least I use it on a
> regular basis.

Use

diff -urN /dev/null $file | ./scripts/checkpatch.pl -

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

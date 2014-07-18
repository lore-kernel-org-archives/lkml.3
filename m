Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030329AbaGROta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:49:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41260 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934609AbaGROt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:49:28 -0400
Date: Fri, 18 Jul 2014 16:49:20 +0200
From: Borislav Petkov <bp@suse.de>
To: Joe Perches <joe@perches.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Richard Weinberger <richard@nod.at>,
        akpm@linux-foundation.org, apw@canonical.com, tytso@mit.edu,
        dwalter@google.com, neilb@suse.de, hch@infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718144920.GE31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C92C86.2030408@metafoo.de>
 <20140718142459.GC31270@pd.tnic>
 <1405694126.14358.30.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1405694126.14358.30.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 07:35:26AM -0700, Joe Perches wrote:
> Using the one-liner above also makes it harder to
> automate checkpatch neatening and avoid using Lindent:

automated checkpatch?? More idiocy... we want less, in case you've
forgotten.

<snip more pointless justification attempts>

Let me state it again:

The thing is called checkpatch and not lindent or checkfile or whatever.
It is supposed to check *patches* and *not* whole files.

If people still want to check whole files, they can do so. But patches
generated from checking whole files are completely ignored by most
maintainers and don't help anyone - not the person who wants to learn to
contribute properly to the kernel and not the maintainer on the other
end who cringes at the gazillion lines patch staring him in the face.

It is about time people understood that and dropped the senseless frenzy
of creating patches with less time spent on thinking about them than
preparing them.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

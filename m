Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762259AbaGROXA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 10:23:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40543 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762163AbaGROW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 10:22:58 -0400
Date: Fri, 18 Jul 2014 16:22:49 +0200
From: Borislav Petkov <bp@suse.de>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Richard Weinberger <richard@nod.at>, akpm@linux-foundation.org,
        apw@canonical.com, joe@perches.com, tytso@mit.edu, dwalter@google.com,
        neilb@suse.de, hch@infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch.pl: Remove --file option
Message-ID: <20140718142249.GB31270@pd.tnic>
References: <1405611268-12463-1-git-send-email-richard@nod.at>
 <53C8CCE1.4000105@roeck-us.net>
 <20140718082324.GA31270@pd.tnic>
 <53C92332.5010807@roeck-us.net>
 <53C92535.2010605@nod.at>
 <20140718135612.GA18432@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140718135612.GA18432@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 06:56:12AM -0700, Guenter Roeck wrote:
> Yes, that came up before. Or I can revert the patch locally, or keep
> an old version of checkpatch around. You make me suffer

Come on, you suffer from a one-liner?! Script it or whatever. Puh-lease!

The thing is inviting lazy wankers from all over the place who refuse to
turn on their brains just so they get a stupid patch into the kernel.
Keeping --file for your convenience is causing much more trouble all
over the place. Kill it already.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

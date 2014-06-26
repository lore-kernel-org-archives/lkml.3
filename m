Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260AbaFZFty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:49:54 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58025 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752109AbaFZFtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:49:53 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 22:49:44 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626054944.GA2490@thin>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
 <1403749983.7977.6.camel@joe-AO725>
 <20140626034430.GA22836@thin>
 <1403756211.7977.22.camel@joe-AO725>
 <20140626050824.GB1645@thin>
 <1403760570.7977.28.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403760570.7977.28.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:29:30PM -0700, Joe Perches wrote:
> On Wed, 2014-06-25 at 22:08 -0700, Josh Triplett wrote:
> 
> > Now, arguably the four leading tabs on those lines suggest the need for
> > some code refactoring; personally, I'd suggest changing DEEP_INDENTATION
> > to flag 4+ tabs rather than 6+ tabs as it currently does.
> 
> There are _way too many_ 4+ tab indents for that to
> be sensible.

Yeah, a quick grep confirmed that.  On the other hand, if *already*
flagging a long line, it makes sense to flag 4+ tabs as potentially
excessive nesting.

- Josh Triplett

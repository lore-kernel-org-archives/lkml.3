Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752920AbaFZDok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 23:44:40 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:42639 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751024AbaFZDoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 23:44:39 -0400
X-Originating-IP: 50.43.32.211
Date: Wed, 25 Jun 2014 20:44:30 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Joe Perches <joe@perches.com>
Cc: Andy Whitcroft <apw@canonical.com>, gregkh@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scripts/checkpatch.pl: Only emit LONG_LINE for --strict
Message-ID: <20140626034430.GA22836@thin>
References: <20140625154629.GA21519@thin>
 <1403741107.28663.9.camel@joe-AO725>
 <20140626022448.GA22091@thin>
 <1403749983.7977.6.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403749983.7977.6.camel@joe-AO725>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 07:33:03PM -0700, Joe Perches wrote:
> On Wed, 2014-06-25 at 19:24 -0700, Josh Triplett wrote:
> > On Wed, Jun 25, 2014 at 05:05:07PM -0700, Joe Perches wrote:
> > > On Wed, 2014-06-25 at 08:46 -0700, Josh Triplett wrote:
> > > > Regardless of the long-standing debate over line width, checkpatch
> > > > should not warn about it by default.
> > > 
> > > I'm not getting involved here.
> > > I don't care much one way or another.
> []
> > I'm not asking you to get involved in the Great Line Length Debate;
> > that's why I didn't attempt to patch CodingStyle or similar.  However, I
> > think it makes sense for *checkpatch* to stop emitting this warning.
> 
> I think checkpatch should encourage people to write code in
> a style that matches CodingStyle as well as the predominant
> styles used in the rest of the kernel.

Not arguing with that, but in this particular case the warning seems
counterproductive to that goal, especially compared to the
DEEP_INDENTATION warning.  More subjective or "to taste" issues tend
to have lower severity in checkpatch.  And CodingStyle *already* says
"unless exceeding 80 columns significantly increases
readability"

- Josh Triplett

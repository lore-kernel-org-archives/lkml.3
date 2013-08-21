Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752187Ab3HUEKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 00:10:10 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53278 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751911Ab3HUEKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 00:10:09 -0400
Message-ID: <1377058207.1936.6.camel@joe-AO722>
Subject: Re: rfc: trivial patches and slow deaths?
From: Joe Perches <joe@perches.com>
To: Rob Landley <rob@landley.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>
Date: Tue, 20 Aug 2013 21:10:07 -0700
In-Reply-To: <1377048987.2737.89@driftwood>
References: <1377043822.2737.86@driftwood>
	 <1377044556.2016.102.camel@joe-AO722> <1377048987.2737.89@driftwood>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-08-20 at 20:36 -0500, Rob Landley wrote:
> On 08/20/2013 07:22:36 PM, Joe Perches wrote:
> > I'm also saying that the trivial tree should
> > have some visibility about whether or not a
> > patch or series will be handled by the trivial
> > maintainer or not.
[]
> > Jiri has not responded to this point.
> He did. Twice.

Not really.

> > Silence about the status of patches that extends
> > for months is not good.
> 
> He has a public git tree.

Yes, I know.

> I've found that if a patch isn't in there, he hasn't picked
> it up yet.

It's the visibility of if/yet/when for the trivial
patches submitted and unresponded to that's the question.

And no, Jiri hasn't responded with any intention of
making any such scheme public.

I think a public patchwork queue like netdev's could
work reasonably well.

http://patchwork.ozlabs.org/project/netdev/list/



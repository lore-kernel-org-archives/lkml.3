Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934912Ab3DQXtt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 19:49:49 -0400
Received: from mail-ia0-f181.google.com ([209.85.210.181]:51538 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab3DQXtq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 19:49:46 -0400
Date: Wed, 17 Apr 2013 18:49:40 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [RFC 5/7] Docs: Expectations for bug reporters and maintainers
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20130417182328.GA7690@xanatos> (from
	sarah.a.sharp@linux.intel.com on Wed Apr 17 13:23:28 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1366242580.18069.116@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2013 01:23:28 PM, Sarah Sharp wrote:
> On Tue, Apr 16, 2013 at 09:15:06PM -0500, Rob Landley wrote:
> > On 04/15/2013 12:33:34 PM, Sarah Sharp wrote:
> > >Outline how often it's polite to ping kernel maintainers about
> > >bugs, and
> > >suggest that kernel maintainers should respond to bugs in 1 to 5
> > >business days.
> >
> > Is there anything in here about the four-level nature of modern
> > maintainership?
> >
> > Patches go from the developer, to the maintainer, to one of Linus's
> > lieutenants, to Linus himself. If you submit a patch to a maintainer
> > they owe you a response. The lieutenant (subsystem maintainer) owes
> > that maintainer a response, and Linus (the project's architect) owes
> > the lieutenant a response.
> 
> Do we want to go into this much detail in a document meant for
> frustrated bug reporters?  Or perhaps we should create a separate
> document about the kernel maintainer hierarchy and reference it here?

My point was that you have to contact the right person to semi-reliably  
get a response, but you're right. That's more about getting patches in  
than getting problems reproduced and diagnosed.

> Also, please note that I'm writing this from the perspective of a  
> driver
> maintainer.  I'm not sure if we've met face to face. :)

Pretty sure we haven't. (You helped me debug a weird usb3 issue once  
via email.)

> > Linus does not owe you, personally, a response. Neither do the
> > subsystem maintainers if you approach them directly with something
> > that should have gone through one of the hundreds of domain-specific
> > maintainers out of the Maintainers file. So the point of going to
> > the right people in sequence and getting their review and
> > signed-off-by lines is to ensure you don't sit there listening to
> > crickets chirping while your patch is ignored. (If you approach
> > Linus directly you may randomly _get_ a response, but there's no
> > guarantee, and usually you won't because he's really busy.)
> 
> This file is about bug reporting, not submitting patches.  I rewrote
...
> TLDR version: Yes, it would be nice if bug reporters could go up the
> hierarchy, but they don't have an easy way to know which subsystem
> maintainers to contact.  Perhaps a new line in MAINTAINERS for the
> subsystem maintainer would be helpful?

Eh, this has gone undocumented for a full decade and nobody but me's  
cared. It seemed related at the time (general interacting with the  
kernel developers), but I guess not.

Rob
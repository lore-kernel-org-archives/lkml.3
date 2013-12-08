Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758853Ab3LHMix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 07:38:53 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:53290 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617Ab3LHMit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 07:38:49 -0500
Date: Sun, 8 Dec 2013 13:38:48 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove unnecessarily gendered language
Message-ID: <20131208123848.GC14108@amd.pavel.ucw.cz>
References: <1386033532-25431-1-git-send-email-matthew.garrett@nebula.com>
 <20131205104808.GA6455@amd.pavel.ucw.cz>
 <1386261314.14035.8.camel@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386261314.14035.8.camel@x230>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2013-12-05 16:35:15, Matthew Garrett wrote:
> On Thu, 2013-12-05 at 11:48 +0100, Pavel Machek wrote:
> > On Mon 2013-12-02 20:18:52, Matthew Garrett wrote:
> > > The kernel as a number of cases of gendered language. The majority of these
> > > refer to objects that don't have gender in English, and so I've replaced
> > > them with "it" and "its". Some refer to people (developers or users), and
> > > I've replaced these with the singular "they" variant. Some are simply
> > > typos that I've fixed up.
> > 
> > Why is this good idea?
> 
> Using "he" to refer to objects without gender is (with some exceptions)
> incorrect in English, so that set should be uncontroversial. "He" is
> usually considered acceptable when referring to an individual of unknown
> gender, but so is "they". The latter version has the advantage of not
> giving the impression that we believe all our users are male.

As you said, "he" is acceptable when referring to an individual of
unknown gender. Disadvantage of "they" is that it makes the text
confusing if not done carefuly. And random sample of 3 changes made it
clear you were not careful...

> > NAK, FWIW.
> 
> Why?

...thus, I believe you are doing the patch for wrong reasons.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

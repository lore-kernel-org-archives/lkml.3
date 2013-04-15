Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933959Ab3DOSjO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:39:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52695 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755092Ab3DOSjM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:39:12 -0400
Date: Mon, 15 Apr 2013 19:39:09 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: dmg <dmg@uvic.ca>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20130415183909.GQ2619@decadent.org.uk>
References: <87r4ifxzwu.fsf@mn.cs.uvic.ca>
 <1365912098.2783.42.camel@deadeye.wl.decadent.org.uk>
 <CAEBXXD8CZumwvOH7gLU+HQNAngHbD7eLFB48qUF_8BeYhk7fNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEBXXD8CZumwvOH7gLU+HQNAngHbD7eLFB48qUF_8BeYhk7fNQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: helping with tracking commits across repos
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 11:21:32AM -0700, dmg wrote:
> Hi Ben,
> 
> On 4/13/13, Ben Hutchings <ben@decadent.org.uk> wrote:
[...]
> > It should be possible to find such backported commits based on a simple
> > regex search over the commit message:
> 
> I took a more aggressive approach. I decided to look for 40 length
> character hashes in the
> comment and patch of the commit.
[...]
> hopefully this solves the use-case you described.

That's great, thankyou.

> The commit logs are being scanned as I write this. It should be done
> in a couple of hours.
 
By the way, I noticed that you're not HTML-escaping the commit
header.

Ben.

-- 
Ben Hutchings
We get into the habit of living before acquiring the habit of thinking.
                                                              - Albert Camus

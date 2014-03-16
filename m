Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932121AbaCPShA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 14:37:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45376 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbaCPSg7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 14:36:59 -0400
Date: Sun, 16 Mar 2014 14:36:51 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PULL] namespaces fixes for 3.14-rcX
Message-ID: <20140316183651.GJ27244@madcap2.tricolour.ca>
References: <874n3ir0uw.fsf_-_@xmission.com>
 <87mwhaplo4.fsf_-_@xmission.com>
 <20140304133004.b565820f60f595a48e621e58@linux-foundation.org>
 <20140304.165122.445822929490466603.davem@davemloft.net>
 <87mwh5d1tf.fsf@xmission.com>
 <20140304145037.d46ee775d293dd1ad60aa8e3@linux-foundation.org>
 <87bnxesqf0.fsf_-_@xmission.com>
 <1394459944.17193.12.camel@localhost>
 <87r469rfop.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87r469rfop.fsf@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/03/10, Eric W. Biederman wrote:
> Eric Paris <eparis@redhat.com> writes:
> 
> > On Sun, 2014-03-09 at 20:06 -0700, Eric W. Biederman wrote:
> >> My efforts to get these fixes noticed by people who care about audit
> >> seem to have landed on deaf ears, so since these are namespace related I
> >> have put them in my tree.
> >
> > This commentary sounds like a pile of crap seeing as how there was a
> > whole discussion around how to handle this stuff, which you were a part
> > of.  And that the audit tree already picked up these 2 patches.
> 
> My apologies for offending.  Last night when I looked the audit tree had
> not been updated in 7 weeks, and Andrew Morton wasn't ready to push
> these fixes to Linus and was looking for someone who would.  Keeping
> important bug fixes in my retransmit queue leaves me very grumpy.

Well, it is offensive.  Please stick to the facts.  Some of us may not
be as smart as you, but continuing to suggest people don't care is
starting to get abusive.

> > In any case, since I haven't sent them to Linus and I'm glad that is
> > done, so feel free to consider this me Acking the pull request.
> 
> Eric

- RGB

--
Richard Guy Briggs <rbriggs@redhat.com>
Senior Software Engineer, Kernel Security, AMER ENG Base Operating Systems, Red Hat
Remote, Ottawa, Canada
Voice: +1.647.777.2635, Internal: (81) 32635, Alt: +1.613.693.0684x3545

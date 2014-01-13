Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaAMXpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 18:45:52 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:45133 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaAMXpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 18:45:50 -0500
Date: Mon, 13 Jan 2014 23:45:38 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Eric Dumazet <edumazet@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] fget*() cleanups
Message-ID: <20140113234538.GQ10323@ZenIV.linux.org.uk>
References: <20140107181258.GA29288@redhat.com>
 <20140108132852.GF10038@linux.vnet.ibm.com>
 <20140108151918.GA5156@redhat.com>
 <20140109011650.GI10038@linux.vnet.ibm.com>
 <20140110153459.GA31491@redhat.com>
 <20140111063438.GY10038@linux.vnet.ibm.com>
 <20140111181908.GA7358@redhat.com>
 <20140111222737.GE10038@linux.vnet.ibm.com>
 <20140113154748.GA6496@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113154748.GA6496@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 04:47:48PM +0100, Oleg Nesterov wrote:
> On 01/11, Paul E. McKenney wrote:
> >
> > On Sat, Jan 11, 2014 at 07:19:08PM +0100, Oleg Nesterov wrote:
> > >
> > > It seems that you misunderstood me, let me send v2 for review.
> >
> > Ah, I did misunderstand you.  For both:
> >
> > Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Thanks!
> 
> While at it, can't we factor out the code in fget*() ?
> 
> Probably I dislike the code duplications too much, but imho fget*()
> abuse the copy-and-paste.
> 
> On top of this series, saves 600 bytes.

Applied, along with fcheck_files() stuff.  Sorry about late reply, I'm
digging through huge piles of mail and putting a queue for -next right
now...

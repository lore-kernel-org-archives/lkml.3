Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932985Ab3CYSkB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 14:40:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932611Ab3CYSj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 14:39:59 -0400
Date: Mon, 25 Mar 2013 14:39:53 -0400
From: Dave Jones <davej@redhat.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: ipc/testmsg GPF.
Message-ID: <20130325183953.GA428@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Hurley <peter@hurleysoftware.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130307213819.GB19543@redhat.com>
 <1362788821.7755.12.camel@thor.lan>
 <20130311182621.GA24965@redhat.com>
 <1363028602.3234.38.camel@thor.lan>
 <20130325163703.GA19064@redhat.com>
 <1364236133.3681.2.camel@thor.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364236133.3681.2.camel@thor.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 25, 2013 at 02:28:53PM -0400, Peter Hurley wrote:
 
 > > bad news: Turns out my recent testing where I thought your patches fixed
 > > this was incorrect.  I had excluded fuzz testing of msgrcv, so it was never
 > > getting exercised.
 > 
 > I think you might have applied the wrong series. See below.
 
The last lot I applied from you was 30-40 or so patches, then some of them
got applied upstream, so I lost track of just what's left outstanding.

 > >  879                         tmp = tmp->next;
 > 
 > This source line does not exist with the 'ipc IPC_MSGCOPY fixes'
 > patchset applied.

Hmm, I don't see that in my lkml folder for this month.
Can you bounce me a copy ?

	Dave

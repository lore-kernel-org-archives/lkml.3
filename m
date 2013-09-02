Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab3IBVLj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 17:11:39 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:36169 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758969Ab3IBVLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 17:11:38 -0400
Message-ID: <1378156296.1953.117.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Joe Perches <joe@perches.com>
To: David Howells <dhowells@redhat.com>
Cc: Josh Triplett <josh@joshtriplett.org>, Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Date: Mon, 02 Sep 2013 14:11:36 -0700
In-Reply-To: <13834.1378155023@warthog.procyon.org.uk>
References: <20130902195056.GB32628@leaf>
	 <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
	 <1378148367.1953.98.camel@joe-AO722>
	 <13834.1378155023@warthog.procyon.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-02 at 21:50 +0100, David Howells wrote:
> Josh Triplett <josh@joshtriplett.org> wrote:
> 
> > > There are many checkpatch rules (like semicolons) that
> > > are not in CodingStyle.
> > 
> > It's a rule of thumb, not a mandate.  In *general*, checkpatch.pl should
> > not be enforcing style rules that aren't documented in CodingStyle.
> 
> Except that it becomes a mandate when someone runs it automatically against
> every one of your patches and then sends you an email for each patch it finds
> a checkpatch niggle against...

I think that any robot sending such checkpatch-only
emails should be disabled.

I know of 2 email robots.

Fengguang Wu's very useful build robot
sends out emails on build failures.
I think that's great.

Wang Shilong <wangshilong1991@gmail.com>
sent me an automated checkpatch email I
thought was not useful.

Does anyone know of other checkpatch robots?



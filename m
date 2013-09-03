Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759259Ab3ICAr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 20:47:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:37903 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753871Ab3ICAr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 20:47:56 -0400
Message-ID: <1378169274.1953.139.camel@joe-AO722>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
From: Joe Perches <joe@perches.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Wang Shilong <wangshilong1991@gmail.com>
Date: Mon, 02 Sep 2013 17:47:54 -0700
In-Reply-To: <20130903003958.GA6855@localhost>
References: <20130902195056.GB32628@leaf>
	 <9976.1378132260@warthog.procyon.org.uk>
	 <1378138205.1953.66.camel@joe-AO722> <20130902181510.GA29787@leaf>
	 <20130902181856.GB29787@leaf> <20130902153945.6d7e510c@samsung.com>
	 <1378148367.1953.98.camel@joe-AO722>
	 <13834.1378155023@warthog.procyon.org.uk>
	 <1378156296.1953.117.camel@joe-AO722> <20130903003958.GA6855@localhost>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-09-03 at 08:39 +0800, Fengguang Wu wrote:
> On Mon, Sep 02, 2013 at 02:11:36PM -0700, Joe Perches wrote:
[]
> > Fengguang Wu's very useful build robot
> > sends out emails on build failures.
> > I think that's great.
> 
> Thanks! Yes I'm now running checkpatch these days because some people
> suggested to me that some of the checkpatch warnings do help catch
> real bugs.

Hi Fengguang.

I see, I don't recall receiving one of these so
it must be working just fine.

> However I do try to avoid upsetting people with maybe-subjective
> warnings. A checkpatch report will only be sent when a small fraction
> of error types are detected. Comments are very welcome on how to
> improve this list:

Your list seems reasonable.

I might add:

DOS_LINE_ENDINGS
MODIFIED_INCLUDE_ASM
JIFFIES_COMPARISON
ONE_SEMICOLON



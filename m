Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756703Ab3ICBVI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 21:21:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:9603 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab3ICBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 21:21:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,1010,1367996400"; 
   d="scan'208";a="390134820"
Date: Tue, 3 Sep 2013 09:21:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Shilong Wang <wangshilong1991@gmail.com>, Joe Perches <joe@perches.com>,
        David Howells <dhowells@redhat.com>,
        Andy Whitcroft <apw@canonical.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: [Ksummit-2013-discuss] [PATCH] checkpatch: Add comment about
 updating Documentation/CodingStyle
Message-ID: <20130903012100.GB6855@localhost>
References: <9976.1378132260@warthog.procyon.org.uk>
 <1378138205.1953.66.camel@joe-AO722>
 <20130902181510.GA29787@leaf>
 <20130902181856.GB29787@leaf>
 <20130902153945.6d7e510c@samsung.com>
 <1378148367.1953.98.camel@joe-AO722>
 <13834.1378155023@warthog.procyon.org.uk>
 <1378156296.1953.117.camel@joe-AO722>
 <CAP9B-Q=xO8Rw_wD-tER2U1g4fKfiy01eT7rMAV6V_gCCNpy09Q@mail.gmail.com>
 <20130903003602.GB1614@leaf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903003602.GB1614@leaf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 05:36:03PM -0700, Josh Triplett wrote:
> On Tue, Sep 03, 2013 at 08:26:21AM +0800, Shilong Wang wrote:
> > 2013/9/3 Joe Perches <joe@perches.com>:
> > > Wang Shilong <wangshilong1991@gmail.com>
> > > sent me an automated checkpatch email I
> > > thought was not useful.
> > 
> > I am sorry if i give you any trouble, i have disabled it(in fact, it
> > only has run for a day!)
> 
> I would suggest that you leave it running, but rather than sending mails
> directly, have it prep the mails for you to send after manual review.
> Do some careful scrutiny for false positives and cases where the change
> would not improve the code, and use checkpatch's options to turn off
> the more contentious warnings (like the 80-column warning).  Over time,
> you'll develop a set of options that produce warnings people mostly
> *want* to get notified about.
 
Good suggestions! That's exactly what I'm trying to do. And Joe kindly
showed me the initial list of checkpatch error types suitable for auto
notification.

Coverage is good: the checkpatch robot iterates over every new commit
in the 300+ git trees I collected over time. Some maintainer trees are
skipped because they should already run the check.

Here is the list of reports sent in the last two weeks. They are private
emails directly sent to the commit author and committer.  So far I've not
received complaints on these unsolicited checkpatch reports.

 Aug 23  [netdev-next:master 200/301] WARNING: usb_free_urb(NULL) is safe this check is probably n
 Aug 23  [netdev-next:master 202/301] WARNING: usb_free_urb(NULL) is safe this check is probably n
 Aug 23  [linuxtv-media:master 321/499] ERROR: Unrecognized email address: 'Kyungmin Park <kyungmi
 Aug 23  [linuxtv-media:master 322/499] ERROR: Unrecognized email address: 'Kyungmin Park <kyungmi
 Aug 24  [xlnx:master-next 32/53] WARNING: unnecessary cast may hide bugs, see http://c-faq.com/ma
 Aug 28  [mmotm:master 473/483] WARNING: __func__ should be used instead of gcc specific __FUNCTIO
 Aug 28  [kvm:queue 13/14] ERROR: Unrecognized email address: 'Gleb Natapov @gleb@redhat.com>'
 Aug 29  [dhowells-fs:keys-devel 9/12] WARNING: labels should not be indented
 Aug 29  [jolsa-perf:perf/plugins2 14/20] WARNING: storage class should be at the beginning of the
 Aug 30  [nfs:testing 47/61] ERROR: Unrecognized email address: 'Trond Myklebust <Trond.Myklebust@
 Aug 31  [josef-btrfs:master 74/135] WARNING: kfree(NULL) is safe this check is probably not requi
 Aug 31  [jolsa-perf:perf/toggle6 6/8] WARNING: kfree(NULL) is safe this check is probably not req
 Sep 01  [jolsa-perf:perf/core_plugins 14/24] WARNING: storage class should be at the beginning of

Thanks,
Fengguang


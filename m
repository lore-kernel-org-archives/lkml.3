Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaBBSKU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 13:10:20 -0500
Received: from mx2.parallels.com ([199.115.105.18]:52045 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaBBSKR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 13:10:17 -0500
From: James Bottomley <jbottomley@parallels.com>
To: "rob@landley.net" <rob@landley.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "gleb@kernel.org" <gleb@kernel.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "jkosina@suse.cz" <jkosina@suse.cz>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "henrik@austad.us" <henrik@austad.us>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in
 Documentation/
Thread-Topic: [PATCH] Documentation cleanup, update 00-INDEX files in
 Documentation/
Thread-Index: AQHPHVKOL737ZZGrCE6CDdfybgs7V5qdMbaAgALAOgCAAiOtgIAAubWA
Date: Sun, 2 Feb 2014 18:09:35 +0000
Message-ID: <1391364575.2178.14.camel@dabdike.int.hansenpartnership.com>
References: <1391041675-31683-1-git-send-email-henrik@austad.us>
		<52E9D3EB.1060209@landley.net>
	 <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
	 <52EDEE17.4010205@landley.net>
In-Reply-To: <52EDEE17.4010205@landley.net>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [24.17.213.192]
Content-Type: text/plain; charset=US-ASCII
Content-ID: <912061CEA19C8E4383E8BC4E4E52C845@sw.swsoft.com>
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-02 at 01:04 -0600, Rob Landley wrote:
> Back before kernel.org did its epic barn door locking after the horses 
> escaped, I used to use them to generate HTML indexes for 
> kernel.org/doc/Documentation, but sometime after they took away my 
> ability to rsync updates to that they replaced that directory with a raw 
> git checkout. I'm still waiting for them to replace the HTML versions of 
> the menuconfig help text and the htmldocs output with raw git checkouts too.
> 
> I periodically poke them about it, ala 
> https://bugzilla.kernel.org/show_bug.cgi?id=52721#c7 but the answer is 
> always crickets chirping or "you should upload web pages with git just 
> like you browse the web with git, watch video with git, play skyrim with 
> git, edit code with git, compile code with git... there is no other 
> software tool." At which point I wander off for another 6 months.
> 
> So I used to have a use for it, but since kernel.org got all paranoid I 
> can't use it that way anymore. (That's why I haven't been updating these 
> files when the patches themselves don't. It's on my todo list, but it's 
> really hard to _care_ when they so obviously don't.)

Has it not occurred to you that everyone else moved on from this.  Sure
there were annoying and painful adjustments that had to be made and
processes that had to be completely rebuilt and sure it was hard to
build a chain of trust to people in obscure places but everyone else did
it.

Business people are fond of dividing the world into Doers and Whiners.
I don't entirely buy this because in my personal experience if something
ends up being really hard, Doers like to whine about how hard it was to
do in the pub afterwards ... I know I do, particularly over single
malts.  The essential truth, I think, is that people with the drive to
do something use that drive to overcome obstacles in their path; people
without it use the obstacles as an excuse for why something didn't get
done.  Fundamentally, Open Source is about Doers and thus, while there
are many self help groups for Whiners Open Source lists like LKML aren't
among them.

James


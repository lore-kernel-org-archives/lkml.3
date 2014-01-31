Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754432AbaAaWYq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 17:24:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52012 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbaAaWYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 17:24:45 -0500
Date: Fri, 31 Jan 2014 14:24:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Rob Landley <rob@landley.net>
Cc: Henrik Austad <henrik@austad.us>, LKML doc <linux-doc@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Brown <broonie@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, Gleb Natapov <gleb@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Len Brown <len.brown@intel.com>,
        James Bottomley <JBottomley@parallels.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
Subject: Re: [PATCH] Documentation cleanup, update 00-INDEX files in
 Documentation/
Message-Id: <20140131142442.8030cf06d1d729c8e3a4541c@linux-foundation.org>
In-Reply-To: <52E9D3EB.1060209@landley.net>
References: <1391041675-31683-1-git-send-email-henrik@austad.us>
	<52E9D3EB.1060209@landley.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jan 2014 22:24:11 -0600 Rob Landley <rob@landley.net> wrote:

> On 01/29/14 18:27, Henrik Austad wrote:
> > Some of the 00-INDEX files are somewhat outdated and some folders does not
> > contain 00-INDEX at all. Only outdated (with the notably exception of
> > spi) indexes are touched here, the 169 folders without 00-INDEX has not
> > been touched.
> >
> > This applies to Linus' tip (0e47c969).
> 
> Looks like an improvement.
> 
> Acked-by: Rob Landley <rob@landley.net>

Are these 00-INDEX files actually useful?  I've never opened one of
them in my life.

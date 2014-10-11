Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421AbaJKW0R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 18:26:17 -0400
Received: from casper.infradead.org ([85.118.1.10]:54236 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343AbaJKW0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 18:26:16 -0400
Date: Sat, 11 Oct 2014 23:26:15 +0100
From: Thomas Graf <tgraf@suug.ch>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: paulmck@linux.vnet.ibm.com, "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rhashtable: hang while running tests on boot
Message-ID: <20141011222615.GB14186@casper.infradead.org>
References: <5437E1B3.6020409@oracle.com>
 <20141010142247.GU4880@linux.vnet.ibm.com>
 <5437ED21.2040500@oracle.com>
 <20141011155032.GZ4880@linux.vnet.ibm.com>
 <5439564E.8080105@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5439564E.8080105@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <tgraf@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/14 at 12:09pm, Sasha Levin wrote:
> On 10/11/2014 11:50 AM, Paul E. McKenney wrote:
> >>> > > I am guessing that this happens only when running the resizable hashtable
> >>> > > tests -- if that guess is incorrect, please let me know.
> >> > 
> >> > I've seen it a few times only with rhashtable related traces, if that ever
> >> > changes I'll update - but for now I think it's safe to assume it's rhashtable
> >> > specific.
> > Ah, so this is intermittent.  Joy.
> 
> Yup, I'm seeing it in about 10% of boot attempts.

Have you ever seen any traces outside of the test_rht code?  I'm
trying to figure out whether it's a bug in the test code or in the
hash table itself.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaJKPuj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 11:50:39 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:57405 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaJKPuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 11:50:37 -0400
Date: Sat, 11 Oct 2014 08:50:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: "David S. Miller" <davem@davemloft.net>, tgraf@suug.ch,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: rhashtable: hang while running tests on boot
Message-ID: <20141011155032.GZ4880@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5437E1B3.6020409@oracle.com>
 <20141010142247.GU4880@linux.vnet.ibm.com>
 <5437ED21.2040500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5437ED21.2040500@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101115-0009-0000-0000-00000588505D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:28:49AM -0400, Sasha Levin wrote:
> On 10/10/2014 10:22 AM, Paul E. McKenney wrote:
> > On Fri, Oct 10, 2014 at 09:40:03AM -0400, Sasha Levin wrote:
> >> > Hi all,
> >> > 
> >> > I'm sometimes observing the following hang during boot:
> > Any chance of a .config?  ;-)
> 
> Attached.

OK, and you already have CONFIG_PROVE_RCU=y, so scratch that advice.

> > I am guessing that this happens only when running the resizable hashtable
> > tests -- if that guess is incorrect, please let me know.
> 
> I've seen it a few times only with rhashtable related traces, if that ever
> changes I'll update - but for now I think it's safe to assume it's rhashtable
> specific.

Ah, so this is intermittent.  Joy.

							Thanx, Paul


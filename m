Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751363AbaLPSpH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:45:07 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:53518 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLPSpA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:45:00 -0500
Date: Mon, 15 Dec 2014 19:40:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Ingo Molnar <mingo@kernel.org>, David Lang <david@lang.hm>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        Mike Galbraith <umgwanakikbuti@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141216034045.GM5310@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20141213083055.GI32572@gmail.com>
 <548C60FF.9020607@oracle.com>
 <20141213180752.GI25340@linux.vnet.ibm.com>
 <20141214175007.GA6927@linux.vnet.ibm.com>
 <548E214D.6040706@oracle.com>
 <20141215001123.GK5310@linux.vnet.ibm.com>
 <548E374D.1040003@oracle.com>
 <20141215063331.GL5310@linux.vnet.ibm.com>
 <20141215125641.GA12673@linux.vnet.ibm.com>
 <548EDF14.3090306@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <548EDF14.3090306@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121618-0013-0000-0000-0000071F4335
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 08:16:04AM -0500, Sasha Levin wrote:
> On 12/15/2014 07:56 AM, Paul E. McKenney wrote:
> > And maybe it would help if I did the CONFIG_TASKS_RCU=n case as well as
> > the CONFIG_TASKS_RCU=y case.  Please see below for an updated patch.
> 
> I do have CONFIG_TASKS_RCU=y

OK, back to the drawing board...

							Thanx, Paul


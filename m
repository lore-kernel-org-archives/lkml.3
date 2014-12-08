Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755915AbaLHP5y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 10:57:54 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:50383 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755087AbaLHP5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 10:57:52 -0500
Date: Mon, 8 Dec 2014 07:57:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141208155745.GM25340@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CA+55aFyZOo=HzB_n3gLqswFsN1FcMdumaKLBk+fbhDD3wrvXnA@mail.gmail.com>
 <5481C92E.6020805@oracle.com>
 <CA+55aFxnCxJcg7NgNeqn_P_TugpcHTUk+v21Td25Aw6+2Z8=YA@mail.gmail.com>
 <54846B06.8050906@oracle.com>
 <20141207182420.GG25340@linux.vnet.ibm.com>
 <20141207194304.GA17810@linux.vnet.ibm.com>
 <5484E2AB.1070503@oracle.com>
 <20141208052048.GJ25340@linux.vnet.ibm.com>
 <5485B6B9.7010800@oracle.com>
 <5485C3B5.4000401@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5485C3B5.4000401@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120815-0013-0000-0000-000006E019F3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 08, 2014 at 10:28:53AM -0500, Sasha Levin wrote:
> On 12/08/2014 09:33 AM, Sasha Levin wrote:
> > On 12/08/2014 12:20 AM, Paul E. McKenney wrote:
> >> > I have seen this caused by lost IPIs, but you have to lose two of them,
> >> > which seems less than fully likely.
> > It does seem that it can cause full blown stalls as well, just pretty
> > rarely (notice the lack of any prints before):
> 
> Forgot to mentioned, I cranked the rcu lockup timeout to 300 seconds and got
> that stall.

So with the default of 21 seconds, you presumably get huge numbers of
RCU CPU stall warnings?

							Thanx, Paul


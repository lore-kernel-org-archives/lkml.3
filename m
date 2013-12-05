Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3LERbI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 12:31:08 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:38968 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756809Ab3LERbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 12:31:06 -0500
Date: Thu, 5 Dec 2013 09:31:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: lots of brief rcu stalls.
Message-ID: <20131205173102.GS15492@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20131204232838.GA25592@redhat.com>
 <20131205001614.GI15492@linux.vnet.ibm.com>
 <20131205012206.GA31349@redhat.com>
 <20131205164912.GA1585@linux.vnet.ibm.com>
 <20131205171550.GA30002@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131205171550.GA30002@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13120517-9332-0000-0000-0000026443FD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 12:15:50PM -0500, Dave Jones wrote:
> On Thu, Dec 05, 2013 at 08:49:12AM -0800, Paul E. McKenney wrote:
> 
>  > But what workload are you running that causes this?  The only way I
>  > can think of to make this happen requires that you have at least one
>  > CPU spending more than 21 seconds running continuously in kernel mode.
>  > Is that what you are doing, or have you come up with some other creative
>  > way for this to happen?  In the latter case, I would really like to know
>  > about it in case it exposes yet another flaw in my RCU design.  ;-)
> 
> just the regular trinity runs, so it could be anything.
> (Running a few instances of it, with a couple dozen child processes each to drive up the loadavg)

Well, trinity has caused kernel-mode execution periods in excess of
21 seconds in the past, so I will assume that this is the cause until
further notice.

> if only I had a trace or something that I could start to guess at what was happening :)

Maybe creating such a trace would expose additional bugs.  ;-)

							Thanx, Paul


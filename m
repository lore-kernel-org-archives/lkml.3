Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab3J3VdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:33:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751470Ab3J3VdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:33:19 -0400
Date: Wed, 30 Oct 2013 21:32:55 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>,
        =?iso-8859-1?B?RnLvv71k77+9cmlj?= Weisbecker <fweisbec@gmail.com>,
        Knut Petersen <Knut_Petersen@t-online.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Alasdair G Kergon <agk@redhat.com>
Subject: Re: [dm-devel] FW: Re: [BUG 3.12.rc4] Oops: unable to handle
	kernel paging request during shutdown
Message-ID: <20131030213255.GD24325@agk-dp.fab.redhat.com>
Mail-Followup-To: Greg KH <greg@kroah.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@redhat.com>,
	=?iso-8859-1?B?RnLvv71k77+9cmlj?= Weisbecker <fweisbec@gmail.com>,
	Knut Petersen <Knut_Petersen@t-online.de>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	"dm-devel@redhat.com" <dm-devel@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Paul McKenney <paulmck@linux.vnet.ibm.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Ingo Molnar <mingo@kernel.org>, Alasdair G Kergon <agk@redhat.com>
References: <20131028140015.GA14612@agk-dp.fab.redhat.com> <alpine.LRH.2.02.1310301133180.4090@file01.intranet.prod.int.rdu2.redhat.com> <20131030171844.GA16462@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131030171844.GA16462@kroah.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 10:18:44AM -0700, Greg KH wrote:
> The "module unload" issue is rare, thankfully, but yes, this type of
> function will be showing up in 3.13-rc1 through the btrfs tree as it
> needs that functionality, so feel free to use it to resolve this issue
> if you need it.
 
Excellent!  Though rare, yes, the number of bug reports was still
noticeable so we'll definitely take a look at this now.

Thanks,
Alasdair


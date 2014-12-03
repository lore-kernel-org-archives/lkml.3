Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129AbaLCUVE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 15:21:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbaLCUVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 15:21:02 -0500
Date: Wed, 3 Dec 2014 15:19:47 -0500
From: Dave Jones <davej@redhat.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: paulmck@linux.vnet.ibm.com, Linux Kernel <linux-kernel@vger.kernel.org>,
        rgb@redhat.com, eparis@redhat.com, fweisbec@gmail.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: audit: rcu_read_lock() used illegally while idle
Message-ID: <20141203201947.GA4931@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andy Lutomirski <luto@amacapital.net>, paulmck@linux.vnet.ibm.com,
	Linux Kernel <linux-kernel@vger.kernel.org>, rgb@redhat.com,
	eparis@redhat.com, fweisbec@gmail.com,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>
References: <20141203181922.GA26916@redhat.com>
 <20141203192919.GP25340@linux.vnet.ibm.com>
 <547F6D60.5050007@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <547F6D60.5050007@amacapital.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 12:06:56PM -0800, Andy Lutomirski wrote:
 
 > >> Did something in RCU change recently ?
 > > 
 > > Not since -rc1, as far as I know, anyway.
 > 
 > I have patches to delete this whole fscking sysret fast but not really
 > fast path.  I'll resend them for 3.19.  In the mean time, can you test
 > this patch by itself:
 > 
 > https://git.kernel.org/cgit/linux/kernel/git/luto/linux.git/commit/?h=x86/entry&id=1072a16a8d4ad1b11b8062f76e3236b9771b0fb6

With that applied, I no longer see the trace.

thanks,

	Dave


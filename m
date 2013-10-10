Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab3JJMau (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:30:50 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17396 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752076Ab3JJMat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:30:49 -0400
Date: Thu, 10 Oct 2013 08:30:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Borislav Petkov <bp@alien8.de>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@kernel.org,
        peterz@infradead.org, hpa@linux.intel.com, williams@redhat.com,
        akpm@linux-foundation.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC][PATCH] x86: Lazy disabling of interrupts
Message-ID: <20131010083047.6fb34a12@gandalf.local.home>
In-Reply-To: <20131010090300.GB9929@pd.tnic>
References: <20131009144150.108f7041@gandalf.local.home>
	<20131010001153.1f171bff@gandalf.local.home>
	<20131010.001939.1669180620160012783.davem@davemloft.net>
	<20131010090300.GB9929@pd.tnic>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 11:03:00 +0200
Borislav Petkov <bp@alien8.de> wrote:

 
> That's strange - I see
> 
> "H. Peter Anvin" <hpa@linux.intel.com>
> 
> in the CC list here. Did something get mangled on the way or is Claws
> acting outlook-like?
> 

I just looked at my Address book, and sure enough, when you save an
email with quotes, Claws will strip them when adding it to the address
book. If you use the address book to send email, then it will use it
without quotes. This can explain why Paul wasn't getting a lot of my
emails too :-/

-- Steve

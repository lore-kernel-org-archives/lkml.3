Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab3DOBzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 21:55:15 -0400
Received: from oproxy14-pub.unifiedlayer.com ([67.222.51.224]:60539 "HELO
	oproxy14-pub.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753023Ab3DOBzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 21:55:14 -0400
Message-ID: <1365990909.29519.6.camel@Wailaba2>
Subject: Re: [PATCH] process cputimer is moving faster than its
 corresponding clock
From: Olivier Langlois <olivier@trillion01.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@redhat.com, tglx@linutronix.de, fweisbec@gmail.com,
        schwidefsky@de.ibm.com, rostedt@goodmis.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 21:55:09 -0400
In-Reply-To: <1365758166.17140.35.camel@laptop>
References: <1365184746.874.103.camel@Wailaba2>
	 <1365593710.30071.52.camel@laptop> <1365608911.707.65.camel@Wailaba2>
	 <1365758166.17140.35.camel@laptop>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Identified-User: {5686:box610.bluehost.com:olivierl:trillion01.com} {sentby:smtp auth 173.178.230.31 authed with olivier@trillion01.com}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-04-12 at 11:16 +0200, Peter Zijlstra wrote:
> On Wed, 2013-04-10 at 11:48 -0400, Olivier Langlois wrote:
> > Please explain how expensive it is. All I am seeing is a couple of
> > additions.
> 
> Let me start with this, since your earlier argument also refers to
> this.
> 
> So yes it does look simple and straight fwd, only one addition. However
> its an atomic operation across all threads of the same process. Imagine
> a single process with 512 threads, all running on a separate cpu.
> 
Peter,

It now makes perfect sense. Thank you for your explanation. It is
showing me an aspect that I did overlook.

Greetings,



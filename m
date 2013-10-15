Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932870Ab3JOOPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 10:15:33 -0400
Received: from odin2.bull.net ([129.184.85.11]:46586 "EHLO odin2.bull.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932837Ab3JOOPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 10:15:31 -0400
Date: Tue, 15 Oct 2013 16:15:28 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Andi Kleen <andi@firstfloor.org>, Neil Horman <nhorman@tuxdriver.com>,
        <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        <x86@kernel.org>
Subject: Re: [PATCH] x86: Run checksumming in parallel accross multiple
 alu's
Message-ID: <20131015161528.08c19e92@b012350-ux>
In-Reply-To: <1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
References: <1381510298-20572-1-git-send-email-nhorman@tuxdriver.com>
	<87siw4xy9i.fsf@tassilo.jf.intel.com>
	<20131014202528.GG26880@hmsreliant.think-freely.org>
	<20131015091251.2345b918@b012350-ux>
	<20131015133336.GF2592@two.firstfloor.org>
	<20131015155615.738f03d5@b012350-ux>
	<1381845985.2045.40.camel@edumazet-glaptop.roam.corp.google.com>
Organization: BULL
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.192.1.123]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Tue, 15 Oct 2013 07:06:25 -0700
Eric Dumazet <eric.dumazet@gmail.com> wrote:

> On Tue, 2013-10-15 at 15:56 +0200, Sébastien Dugué wrote:
> > On Tue, 15 Oct 2013 15:33:36 +0200
> > Andi Kleen <andi@firstfloor.org> wrote:
> > 
> > > >   indeed, our typical workload is connected mode IPoIB on mlx4 QDR hardware
> > > > where one cannot benefit from hardware offloads.
> > > 
> > > Is this with sendfile?
> > 
> >   Tests were done with iperf at the time without any extra funky options, and
> > looking at the code it looks like it does plain write() / recv() on the socket.
> > 
> 
> But the csum cost is both for sender and receiver ?

  No, it was only on the receiver side that I noticed it.

> 
> Please post the following :
> 
> perf record -g "your iperf session"
> 
> perf report | head -n 200

  Sorry, but this is 3 years old stuff and I do not have the
setup anymore to reproduce.

  Sébastien.



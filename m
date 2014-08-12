Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123AbaHLK5Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 06:57:16 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:50933 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaHLK5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 06:57:11 -0400
In-Reply-To: <20140812091850.GD6440@redhat.com>
References: <1407659404-razya@il.ibm.com> <20140810083035.0CF58380729@moren.haifa.ibm.com> <20140810194559.GA4344@redhat.com> <20140811.124621.576073630604147753.davem@davemloft.net> <20140812091850.GD6440@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: abel.gordon@gmail.com, Alex Glikson <GLIKSON@il.ibm.com>,
        David Miller <davem@davemloft.net>,
        Eran Raichstein <ERANRA@il.ibm.com>, Joel Nider <JOELN@il.ibm.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Yossi Kuperman1 <YOSSIKU@il.ibm.com>
MIME-Version: 1.0
Subject: Re: [PATCH] vhost: Add polling mode
X-KeepSent: 93E480CE:EFA0854D-C2257D32:003BE092;
 type=4; name=$KeepSent
X-Mailer: IBM Notes Release 9.0.1SHF211 December 19, 2013
Message-ID: <OF93E480CE.EFA0854D-ONC2257D32.003BE092-C2257D32.003C1F49@il.ibm.com>
From: Razya Ladelsky <razya@il.ibm.com>
Date: Tue, 12 Aug 2014 13:57:05 +0300
X-MIMETrack: Serialize by Router on D06ML319/06/M/IBM(Release 8.5.3FP5IF1HF3|November 07, 2013) at
 12/08/2014 13:57:05,
	Serialize complete at 12/08/2014 13:57:05
Content-Type: text/plain; charset="US-ASCII"
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081210-2966-0000-0000-000000CC5EED
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 12/08/2014 12:18:50 PM:

> From: "Michael S. Tsirkin" <mst@redhat.com>
> To: David Miller <davem@davemloft.net>
> Cc: Razya Ladelsky/Haifa/IBM@IBMIL, kvm@vger.kernel.org, Alex 
> Glikson/Haifa/IBM@IBMIL, Eran Raichstein/Haifa/IBM@IBMIL, Yossi 
> Kuperman1/Haifa/IBM@IBMIL, Joel Nider/Haifa/IBM@IBMIL, 
> abel.gordon@gmail.com, linux-kernel@vger.kernel.org, 
> netdev@vger.kernel.org, virtualization@lists.linux-foundation.org
> Date: 12/08/2014 12:18 PM
> Subject: Re: [PATCH] vhost: Add polling mode
> 
> On Mon, Aug 11, 2014 at 12:46:21PM -0700, David Miller wrote:
> > From: "Michael S. Tsirkin" <mst@redhat.com>
> > Date: Sun, 10 Aug 2014 21:45:59 +0200
> > 
> > > On Sun, Aug 10, 2014 at 11:30:35AM +0300, Razya Ladelsky wrote:
> >  ...
> > > And, did your tests actually produce 100% load on both host CPUs?
> >  ...
> > 
> > Michael, please do not quote an entire patch just to ask a one line
> > question.
> > 
> > I truly, truly, wish it was simpler in modern email clients to delete
> > the unrelated quoted material because I bet when people do this they
> > are simply being lazy.
> > 
> > Thank you.
> 
> Lazy - mea culpa, though I'm using mutt so it isn't even hard.
> 
> The question still stands: the test results are only valid
> if CPU was at 100% in all configurations.
> This is the reason I generally prefer it when people report
> throughput divided by CPU (power would be good too but it still
> isn't easy for people to get that number).
> 

Hi Michael,

Sorry for the delay, had some problems with my mailbox, and I realized 
just now that 
my reply wasn't sent.
The vm indeed ALWAYS utilized 100% cpu, whether polling was enabled or 
not.
The vhost thread utilized less than 100% (of the other cpu) when polling 
was disabled.
Enabling polling increased its utilization to 100% (in which case both 
cpus were 100% utilized). 


> -- 
> MST
> 


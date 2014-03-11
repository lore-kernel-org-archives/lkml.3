Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072AbaCKS3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 14:29:30 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:58571
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751221AbaCKS31 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 14:29:27 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz8275ch17326ah8275dh1de097h186068hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Tue, 11 Mar 2014 11:29:13 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Michal Simek <monstr@monstr.eu>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] tty: xuartps: Rebranding + DT documentation
References: <1394487610-2419-1-git-send-email-soren.brinkmann@xilinx.com>
 <531EE993.80400@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <531EE993.80400@monstr.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b4e6dfe6-ad49-4d81-855b-8dd905665616@VA3EHSMHS039.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-11 at 11:46AM +0100, Michal Simek wrote:
> On 03/10/2014 10:40 PM, Soren Brinkmann wrote:
> > Hi,
> > 
> > this series rebrands the Xilinx PS UART driver as Cadence UART and
> > documents its DT bindings (+ some clean up along the way).
> > 
> > The rebranding goes as far as reasonable. Things like file name, kconfig
> > symbols and other things with user space impact are left as is. Please
> > refer to the discussion in the RFC threads[1-2] for more details.
> > 
> > Similar the DT binding has been extended. In addition to the new and
> > preferred Cadence binding, the current xuartps binding is maintained.
> > Though, only the Cadence names for clock-names are documented.
> > 
> > References:
> >  [1]  https://lkml.org/lkml/2014/3/4/405
> >  [2]  https://lkml.org/lkml/2014/3/7/450
> > 
> > v2:
> >  - no changes regarding the patches
> >  - fixed (I sincerely hope) email recipients
> > 
> > Changes from the latest RFC:
> >  - squashed function/symbol renaming into 'tty: xuartps: Rebrand driver
> >    as Cadence UART'
> >  - Revised the commit message of 'tty: xuartps: Don't write IRQ disable
> >    register to enable interrupts' (was 'tty: xuartps: Remove bogus
> >    comment and register write'
> 
> One more thing. I was thinking this is based on my 3 patches I have
> already sent to mainline. But as I see they are not applied yet.
> 
> https://lkml.org/lkml/2014/1/21/107

I think my cleanup patch covers these changes as well. I'll see if it
makes sense to separate out this patch.

> https://lkml.org/lkml/2014/1/21/101

This is obsolete with the rebranding, IMHO.

> http://www.spinics.net/lists/arm-kernel/msg302796.html

I can add this to this series.

	Sören



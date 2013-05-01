Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761483Ab3EAPka (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 11:40:30 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:41077
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755164Ab3EAPkU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 11:40:20 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh146fI1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bh8275dhz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh906i1155h)
Date: Wed, 1 May 2013 08:39:35 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Michal Simek <michal.simek@xilinx.com>,
        Josh Cartwright <joshc@eso.teric.us>,
        Mike Turquette <mturquette@linaro.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, Jiri Slaby <jslaby@suse.cz>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 1/7] tty: xuartps: Sort #includes alphabetically
References: <1367366284-28304-1-git-send-email-soren.brinkmann@xilinx.com>
 <1367366284-28304-2-git-send-email-soren.brinkmann@xilinx.com>
 <20130501000048.GA1840@kroah.com>
 <cbd8c55c-066b-4396-9a4b-97d58a93b573@DB8EHSMHS005.ehs.local>
 <20130501002321.GB7435@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130501002321.GB7435@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <79ff34b1-0494-4118-a60d-cd5b536d3daa@VA3EHSMHS006.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 05:23:21PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Apr 30, 2013 at 05:05:40PM -0700, Sören Brinkmann wrote:
> > On Tue, Apr 30, 2013 at 05:00:48PM -0700, Greg Kroah-Hartman wrote:
> > > On Tue, Apr 30, 2013 at 04:57:58PM -0700, Soren Brinkmann wrote:
> > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > > CC: Jiri Slaby <jslaby@suse.cz>
> > > > CC: linux-serial@vger.kernel.org
> > > 
> > > Why would you need/want to do this?
> > I often come across duplicated includes. Having some kind of order helps
> > avoiding that, imho.
> 
> We have a tool to handle duplicated includes, no need to put them in
> sorted order for them to be detected.
During conflict resolution, I find it easier when there is some order.
Anyway, consider it dropped.

	Sören



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579AbaCDVBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 16:01:33 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:16912
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754683AbaCDVBa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 16:01:30 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(z579ehz98dIc89bh936eI146fI1432I1418Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h906i1155h)
Date: Tue, 4 Mar 2014 13:00:55 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Eli Billauer <eli.billauer@gmail.com>
CC: <chris@printf.net>, <michal.simek@xilinx.com>, <linux-mmc@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Mike Looijmans <mike.looijmans@topic.nl>
Subject: Re: [PATCH v2] mmc: sdhci: add quirk for broken write protect
 detection
References: <1393759200-22819-1-git-send-email-eli.billauer@gmail.com>
 <74003aec-1707-4f43-b947-df148d573fa1@TX2EHSMHS038.ehs.local>
 <53163247.8000904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <53163247.8000904@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <ae0f71ac-c5f7-4af7-a9ba-c019cec19ebf@AM1EHSMHS017.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-03-04 at 10:06PM +0200, Eli Billauer wrote:
> Hello Sören,
> 
> wp-inverted solves the practical problem indeed, and fools the
> driver into thinking that the card has an inverted write protection
> sensor, and the logic zero that it finds in the hardware register
> means that the card isn't write protected.
> 
> I'm insisting on this patch, because I think that the device tree
> should describe the hardware as it is, and not fool the driver into
> behaving the way we want it to. These tricks always bite back later
> on.
Well, why is broken-wp more accurate than wp-inverted? Strictly
speaking the WP is there and working, it's just tied off to some value
you want to have interpreted the other way.
Anyway, seems like this is solvable with wp-inverted and whether the
additional quirk is needed I leave to others do decide.

	Sören



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaAMRMB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:12:01 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:53953
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754320AbaAMRLz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:11:55 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h906i1155h)
Date: Mon, 13 Jan 2014 09:11:41 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Chris Ball <chris@printf.net>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Michal Simek <michal.simek@xilinx.com>
Subject: Re: linux-next: manual merge of the mmc tree with Linus' tree
References: <20140113131700.840c214536826d7e9a92ef8b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140113131700.840c214536826d7e9a92ef8b@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <31979761-213c-4b65-b14a-b6ef3b2ca60d@AM1EHSMHS002.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 01:17:00PM +1100, Stephen Rothwell wrote:
> Hi Chris,
> 
> Today's linux-next merge of the mmc tree got a conflict in MAINTAINERS
> between commit c2fd4e380322 ("MAINTAINERS: set up proper record for
> Xilinx Zynq") from Linus' tree and commit 45f210424b4b ("mmc: arasan: Add
> driver for Arasan SDHCI") from the mmc tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix is correct, AFAICT.

	Thanks,
	Sören



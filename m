Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760179Ab3GZVMD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:12:03 -0400
Received: from co1ehsobe006.messaging.microsoft.com ([216.32.180.189]:47429
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756881Ab3GZVL6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:11:58 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h668h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh906i1155h192ch)
Date: Fri, 26 Jul 2013 14:11:52 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Mike Turquette <mturquette@linaro.org>
CC: <monstr@monstr.eu>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Zynq clk fixes
References: <51F26716.6030701@monstr.eu>
 <20130726200703.7598.86150@quantum>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20130726200703.7598.86150@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <a76b3a5d-dadc-43b3-87ee-3c65258c15d7@CO1EHSMHS029.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 01:07:03PM -0700, Mike Turquette wrote:
> Quoting Michal Simek (2013-07-26 05:09:58)
> > Hi Mike, [cc: Arnd and Olof]
> > 
> > Soren has found two bug fixes in zynq clk code.
> > Can you please add these two patches to your tree?
> > Will be great if you can add them to v3.11.
> > 
> > Arnd, Olof: I expect that all these clock changes should go through Mike.
> > If I am wrong please let me know.
> 
> Looks right to me. Do these fix regressions in the current -rc cycle?

I doubt there are real regressions. But since it's still early in
the release cycle and the driver was added in this merge window, I'd prefer
having it hit a release kernel with these fixes included.

	Sören



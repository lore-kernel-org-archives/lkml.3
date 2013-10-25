Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab3JYWlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 18:41:14 -0400
Received: from [216.32.180.14] ([216.32.180.14]:37779 "EHLO
	va3outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751895Ab3JYWlN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 18:41:13 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -1
X-BigFish: VPS-1(zz98dIc89bh1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh906i1155h192ch)
Date: Fri, 25 Oct 2013 15:39:18 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Aldo Iljazi <me@aldo.io>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposal for menuconfig removal
References: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <f8db164d-0937-4f90-90ce-4543d6a8549d@VA3EHSMHS031.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 02:56:33PM +0300, Aldo Iljazi wrote:
> Since nconfig is there, menuconfig is redundant.
> 
> I am proposing to remove it from the kernel.

Pleas don't. I never use nconfig (the color scheme always scared me
away) and only use menuconfig.
Also, this would break a lot of documentation out there in wikis and
a hell lot of other places that tell people to configure a kernel using
'make menuconfig'.

	Sören



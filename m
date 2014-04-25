Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaDYQ5g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 12:57:36 -0400
Received: from va3ehsobe004.messaging.microsoft.com ([216.32.180.14]:37947
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751236AbaDYQ5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 12:57:35 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432I14ffIzz1f42h2148h1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6h208chzzz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h268bh26d3h906i2673i1155h)
Date: Fri, 25 Apr 2014 09:57:04 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: how to include already compiled object files to kernel
References: <D854C92F57B1B347B57E531E78D05EAD574BFA6D@BGSMSX104.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <D854C92F57B1B347B57E531E78D05EAD574BFA6D@BGSMSX104.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <eef5a9e1-9a24-4688-b0ba-bae0382bd370@VA3EHSMHS026.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 04:24PM +0000, Pallala, Ramakrishna wrote:
> HI All,
> 
> I have received few kernel library .o (object files) from third party and I am planning to include in our kernel tree. As the library contains some proprietary algorithms  the sources are not shared.
> 
> How can I include this library .o files to my kernel and if this kernel is release to customers will there be any license issues? Third party says the sources are under GPL.

Doesn't GPL mandate that you would get access to the sources as well?

	Soren



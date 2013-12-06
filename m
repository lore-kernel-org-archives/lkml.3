Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751262Ab3LFGEx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 01:04:53 -0500
Received: from mail-db9lp0249.outbound.messaging.microsoft.com ([213.199.154.249]:29399
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750752Ab3LFGEt convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 01:04:49 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371I936eI542I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h1de097hz2fh95h109h839h944hd24hf0ah119dh1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h2216h2336h906i1155h)
From: Jagannadha Sutradharudu Teki 
	<jagannadha.sutradharudu-teki@xilinx.com>
To: Joe Perches <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Whitcroft <apw@canonical.com>
Subject: RE: [PATCH] checkpatch: Do not hardcode perl path
Thread-Topic: [PATCH] checkpatch: Do not hardcode perl path
Thread-Index: AQHO8fNvyVeQ47REv0atuo+aVjq0eZpGrTLw
Date: Fri, 6 Dec 2013 06:04:37 +0000
References: <b26e8934-caba-4385-bd32-8f48e2e99826@VA3EHSMHS026.ehs.local>
 <1386273109.10003.12.camel@joe-AO722>
In-Reply-To: <1386273109.10003.12.camel@joe-AO722>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.23.98.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-RCIS-Action: ALLOW
Message-ID: <1c130cef-3be7-408c-867b-5a3de863a831@DB9EHSMHS016.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Joe Perches [mailto:joe@perches.com]
> Sent: Friday, December 06, 2013 1:22 AM
> To: Jagannadha Sutradharudu Teki
> Cc: linux-kernel@vger.kernel.org; Andy Whitcroft; Jagannadha Sutradharudu
> Teki
> Subject: Re: [PATCH] checkpatch: Do not hardcode perl path
>
> On Thu, 2013-12-05 at 16:53 +0530, Jagannadha Sutradharudu Teki wrote:
> > checkpatch.pl requires perl v5.10.0 to run but it doesn't require to
> > place in /usr/bin/perl Use env to ensure that the interpreter used is
> > the first one on environment's $PATH on system with several versions
> > of perl installed.
>
> I don't have an opinion on this patch.

fyi: I have some notes here - this change will took the perl bin(if user explicitly use perl instead of from /usr/bin/perl) from bashrc instead of taking /usr/bin/perl all the time.

Jagan.



This email and any attachments are intended for the sole use of the named recipient(s) and contain(s) confidential information that may be proprietary, privileged or copyrighted under applicable law. If you are not the intended recipient, do not read, copy, or forward this email message or any attachments. Delete this email message and any attachments immediately.



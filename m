Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3KTQ52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 11:57:28 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:27018
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753822Ab3KTQ50 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 11:57:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h1155h)
Message-ID: <1384966640.1403.421.camel@snotra.buserror.net>
Subject: Re: BUG: Patch "Convert some mftb/mftbu into mfspr" breaks MPC885
From: Scott Wood <scottwood@freescale.com>
To: leroy christophe <christophe.leroy@c-s.fr>
CC: LinuxPPC-dev <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>,
        Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Wed, 20 Nov 2013 10:57:20 -0600
In-Reply-To: <528C82D1.4090803@c-s.fr>
References: <528C82D1.4090803@c-s.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-11-20 at 10:37 +0100, leroy christophe wrote:
> Scott,
> 
> The patch "Convert some mftb/mftbu into
> mfspr" (beb2dc0a7a84be003ce54e98b95d65cc66e6e536) breaks startup on
> MPC885.
> 
> The CPU traps (SoftwareEmulation trap) at sched_clock() when trying to
> read TBU with mfspr.
> 
> Reverting the patch solves the issue.
> 
> What's the prefered way to fix this ?

I guess we need to add an ifdef.

-Scott




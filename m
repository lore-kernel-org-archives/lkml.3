Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755553Ab3G2WJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:09:38 -0400
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:23358 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab3G2WJg convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:09:36 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23h1155h)
Date: Mon, 29 Jul 2013 17:09:32 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v7 1/3] DMA: Freescale: revise device tree binding
 document
To: <hongbo.zhang@freescale.com>
CC: <vinod.koul@intel.com>, <djbw@fb.com>, <leoli@freescale.com>,
        <linuxppc-dev@lists.ozlabs.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Hongbo Zhang <hongbo.zhang@freescale.com>
References: <1375094944-3343-1-git-send-email-hongbo.zhang@freescale.com>
	<1375094944-3343-2-git-send-email-hongbo.zhang@freescale.com>
In-Reply-To: <1375094944-3343-2-git-send-email-hongbo.zhang@freescale.com>
	(from hongbo.zhang@freescale.com on Mon Jul 29 05:49:02 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1375135772.30721.59@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 05:49:02 AM, hongbo.zhang@freescale.com wrote:
> From: Hongbo Zhang <hongbo.zhang@freescale.com>
> 
> This patch updates the discription of each type of DMA controller and  
> its
> channels, it is preparation for adding another new DMA controller  
> binding, it
> also fixes some defects of indent for text alignment at the same time.
> 
> Signed-off-by: Hongbo Zhang <hongbo.zhang@freescale.com>

ACK, but next time please do the whitespace fixes as a separate patch  
so that it's easier to see what's actually changing.

-Scott

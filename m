Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab3BUCdl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 21:33:41 -0500
Received: from tx2ehsobe001.messaging.microsoft.com ([65.55.88.11]:27918 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751828Ab3BUCdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 21:33:39 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dIc3f2I1432Izz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 21 Feb 2013 10:33:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Sasha Levin <levinsasha928@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>,
        Ilya Zykov <ilya@ilyx.ru>, Dave Jones <davej@redhat.com>,
        Michael Ellerman <michael@ellerman.id.au>
Subject: Re: [PATCH v4 00/32] ldisc patchset
Message-ID: <20130221023349.GA17738@S2101-09.ap.freescale.net>
References: <1360095638-6624-1-git-send-email-peter@hurleysoftware.com>
 <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1361390599-15195-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 03:02:47PM -0500, Peter Hurley wrote:
> [-cc Alan Cox]
> 
> Sebastian, please re-test your g_nokia+dummy_hcd testcase with
> this series.
> 
> Sasha and Dave, my trinity testbeds die in other areas right now;
> I would really appreciate if you would please re-test this series.
> 
> Michael and Shawn, I'd appreciate if you test with this series
> although I know it won't WARN because this patchset removes it.

On imx51 and imx6q:

Tested-by: Shawn Guo <shawn.guo@linaro.org>


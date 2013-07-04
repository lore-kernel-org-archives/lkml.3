Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756622Ab3GDNtG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 09:49:06 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:52422
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752610Ab3GDNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 09:49:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -2
X-BigFish: VS-2(zz98dI1432Izz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz17326ah8275dhz2dh87h2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Thu, 4 Jul 2013 21:49:32 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Stehle Vincent-B46079 <B46079@freescale.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "festevam@gmail.com" <festevam@gmail.com>
Subject: Re: Mainline crashes in wm8962_probe() on i.MX6
Message-ID: <20130704134930.GC11046@S2101-09.ap.freescale.net>
References: <F7C43F8B2814514CA05F3436BC68046EF3A272@039-SN2MPN1-011.039d.mgd.msft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <F7C43F8B2814514CA05F3436BC68046EF3A272@039-SN2MPN1-011.039d.mgd.msft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 04, 2013 at 10:44:11AM +0000, Stehle Vincent-B46079 wrote:
> Hi,
> 
> Mainline of today* will not boot anymore on i.MX6 with ARM config imx_v6_v7_defconfig. It crashes in wm8962_probe() (see log below).
> 
> Bisecting points at merge commit 1286da8bc009cb2aee7f285e94623fc974c0c983, but its two "parents" commits do not crash.

Yeah, I just ran into it with linux-next and reported it there [1].  I
will send a formal patch for it soon.

Shawn

[1] http://thread.gmane.org/gmane.linux.alsa.devel/109844


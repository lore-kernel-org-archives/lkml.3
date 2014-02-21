Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466AbaBUBXC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 20:23:02 -0500
Received: from va3ehsobe006.messaging.microsoft.com ([216.32.180.16]:13385
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754337AbaBUBW7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 20:22:59 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zz98dI9371Ic89bh936eI1454I1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh8275dh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh906i1155h)
Date: Thu, 20 Feb 2014 17:22:51 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Grant Likely <grant.likely@linaro.org>
CC: Sachin Kamat <sachin.kamat@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hao <haokexin@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] Bugfix for of_match_node ordering
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
 <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
 <CACxGe6sg7FpJqAUjkU5DkUpiV_mDbtSV3RETtiQdACUXhRtRrg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <CACxGe6sg7FpJqAUjkU5DkUpiV_mDbtSV3RETtiQdACUXhRtRrg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <91d21c6c-a87a-46bf-8036-c8f769e32399@VA3EHSMHS018.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant,

On Thu, 2014-02-20 at 11:29AM +0000, Grant Likely wrote:
> On Thu, Feb 20, 2014 at 8:39 AM, Sachin Kamat <sachin.kamat@linaro.org> wrote:
> > Hi Grant,
> >
> > I observe the following boot failure with today's (next-20140220) linux-next
> > tree on Exynos based boards with the default exynos_defconfig.
> 
> Ugh, nested locking. that is not good. Kevin's patch looks correct and
> I'll merge it in. I'm a little disturbed though that you're the only
> one who has reported problems. Looking at what it does I would expect
> pretty much every SMP platform for freak out about this, but I've
> heard nothing from the powerpc guys.
> 
> I'll merge in the fix of course, but I'd like to know what I'm missing.

FWIW, I see a deadlock on Zynq (ARM) as well. The proposed patch
resolves it. Feel free to add my
Tested-by: Soren Brinkmann <soren.brinkmann@xilinx.com>

	Sören



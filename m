Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735AbaCMKIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:08:42 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40052 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753488AbaCMKIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:08:40 -0400
Date: Thu, 13 Mar 2014 11:08:38 +0100
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>,
        zmxu@marvell.com, jszhang@marvell.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] ARM: dts: berlin2q: add the Marvell Armada 1500 pro
 (BG2Q) device tree
Message-ID: <20140313100838.GA4418@piout.net>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
 <1394622364-6848-2-git-send-email-antoine.tenart@free-electrons.com>
 <20140312122210.GA3040@piout.net>
 <532180E0.9060108@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532180E0.9060108@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/03/2014 at 09:56:48 +0000, Sebastian Hesselbarth wrote :
> On 03/12/2014 12:22 PM, Alexandre Belloni wrote:
> >
> >The 25MHz crystal is on the board, please move it to the board dts.
> 
> If you can confirm that sysmgr clock comes directly from this crystal,
> I agree. If it is fed into a pll and can possibly be modified or gated,
> make it depend on a 25MHz board crystal. If 25MHz is the only option
> for this clock input, I could also live with it being part of the SoC
> description.
> 

Yeah, after more discussion, the 25 MHz crystl is the only option and it
is fed to an oscillator that generate the reference clock for the PLLs.
It is probably fine to let it in the dtsi.

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966574AbaLLTk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 14:40:28 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49170 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932581AbaLLTk0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 14:40:26 -0500
Date: Fri, 12 Dec 2014 13:40:01 -0600
From: Nishanth Menon <nm@ti.com>
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
CC: <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: ARM: OMAP5/DRA7: Fix counter frequency drift for AM572x errata
 i856
Message-ID: <20141212194001.GA30966@kahuna>
References: <20141211204116.GT24110@csclub.uwaterloo.ca>
 <20141211204308.GU24110@csclub.uwaterloo.ca>
 <548B27E5.4090108@ti.com>
 <20141212192303.GY24110@csclub.uwaterloo.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20141212192303.GY24110@csclub.uwaterloo.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14:23-20141212, Lennart Sorensen wrote:
> I was trying to avoid making the code mroe complicated for the other
> CPUs using this code, but I suppose since it runs only at boot once,
> that probably isn't really a great concern.

we try and avoid soc_is or cpu_is as much as possible and depend usually
on compatible to mark the change..
> 
> I will try changing the flow and send an updated version.

k, thanks. lets go through your next rev to see if we can improve on the
same. btw, nice catch :) - thanks for proposing a fix.
-- 
Regards,
Nishanth Menon

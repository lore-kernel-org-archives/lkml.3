Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790Ab3DMEsr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 00:48:47 -0400
Received: from plane.gmane.org ([80.91.229.3]:52716 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755Ab3DMEsq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 00:48:46 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: auxsvr@gmail.com
Subject: Re: sleep/fan problem bisected to 73201dbec64aebf6b0dca855b523f437972dc7bb
Date: Sat, 13 Apr 2013 07:48:37 +0300
Message-ID: <kkao31$hn2$1@ger.gmane.org>
References: <20130412120831.1402b440@chukar.edge2.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: cust-27-63.on5.ontelecoms.gr
User-Agent: KNode/4.10.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jake Edge wrote:

> 
> Hi Peter,
> 
> I have been having a problem on my laptop (HP Compaq 2510p) over the
> last two months with >= 3.7 kernels.  After the first resume, it turns
> on the fan and leaves it running at top speed no matter what the system
> is doing.
> The output of "sensors" is interesting ... for "temp6" in
> "acpitz-virtual-0" it sits at +100C (near the +110C critical level)
> when things have gone bad (just in Fedora or my kernels >=3.7, not in
> the bisect, cuz those don't come back from the sleep) ... in the "good"
> case, it normally sits around 30, but goes as high as 50 (and sometimes
> reports 0 for a try or two -- frozen motherboard! :) ...
> 
> thoughts on this?  Other info you need or things I should be trying?

This is known, see https://lkml.org/lkml/2012/12/4/428 for more details.

> thanks,
> 
> jake

Regards,
Peter


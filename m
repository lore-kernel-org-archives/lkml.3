Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3JJJs2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 05:48:28 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:53045 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752256Ab3JJJs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 05:48:27 -0400
Date: Thu, 10 Oct 2013 10:48:25 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG report about ipt_do_table( )
Message-ID: <20131010094824.GF3817@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1014D1A0971B1@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 06:16:05AM +0100, Wang, Yalin wrote:
> Dear all, 

Hello,

> We encounter a crash in ipt_do_table( ) function 
> During our stability test .
> 
> The CPU is  qcom msm8960 / dual core  , linux kernel version is 3.4

I appreciate that this is a mammoth task, but can you reproduce this failure
with a mainline kernel (3.12-rc4)? If you suspect a synchronisation issue in
core code, I'm afraid you'll have to show the failure with the current
sources.

Will

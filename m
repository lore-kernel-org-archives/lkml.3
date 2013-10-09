Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238Ab3JIKyB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 06:54:01 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:62169 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611Ab3JIKyA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 06:54:00 -0400
Date: Wed, 9 Oct 2013 11:53:57 +0100
From: Will Deacon <will.deacon@arm.com>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'linux-arm-msm-owner@vger.kernel.org'" 
	<linux-arm-msm-owner@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: SDIV / UDIV  Question
Message-ID: <20131009105357.GC6564@mudshark.cambridge.arm.com>
References: <35FD53F367049845BC99AC72306C23D1014D1A0971AC@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35FD53F367049845BC99AC72306C23D1014D1A0971AC@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 09, 2013 at 08:08:05AM +0100, Wang, Yalin wrote:
> I have a question about sdiv/ udiv  instructions :
> In  armv7 A/R  TRM, it said sdiv/udiv will cause 
> Divide by zero as undefined exception or just return zero
> (decided by implementation) .
> 
> So  in kernel ,  should we need register a undef hook to 
> Get this undef exception and send SIGFPE to user space
> Process ?  

As far as I can see, this can only happen for R-class cores,
based on SCTLR.DZ.

Will

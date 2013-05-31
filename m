Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab3EaQxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:53:40 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37981 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752582Ab3EaQxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:53:32 -0400
Date: Fri, 31 May 2013 17:52:50 +0100
From: Will Deacon <will.deacon@arm.com>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
Message-ID: <20130531165250.GU4928@mudshark.cambridge.arm.com>
References: <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B86D@CNBJMBX05.corpusers.net>
 <20130531084638.GB4928@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B874@CNBJMBX05.corpusers.net>
 <20130531111305.GI4928@mudshark.cambridge.arm.com>
 <alpine.LFD.2.03.1305311247280.30828@syhkavp.arg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.03.1305311247280.30828@syhkavp.arg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 05:48:56PM +0100, Nicolas Pitre wrote:
> On Fri, 31 May 2013, Will Deacon wrote:
> 
> > Hard to tell without context. You can take a look at my git tree if you
> > like (I fixed it up based on Nico's comment):
> > 
> >   https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=misc-patches
> 
> If you like, you may add "Reviewed-by: Nicolas Pitre <nico@linaro.org>" 
> to it.

Cheers Nicolas, will do.

Will

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab3EaQtA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 12:49:00 -0400
Received: from relais.videotron.ca ([24.201.245.36]:19701 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab3EaQs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 12:48:57 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; CHARSET=US-ASCII
Date: Fri, 31 May 2013 12:48:56 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: Will Deacon <will.deacon@arm.com>
Cc: "Wang, Yalin" <Yalin.Wang@sonymobile.com>,
        "'richard -rw- weinberger'" <richard.weinberger@gmail.com>,
        "'linux-arch@vger.kernel.org'" <linux-arch@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: A bug about system call on ARM
In-reply-to: <20130531111305.GI4928@mudshark.cambridge.arm.com>
Message-id: <alpine.LFD.2.03.1305311247280.30828@syhkavp.arg>
References: <35FD53F367049845BC99AC72306C23D1610991B85E@CNBJMBX05.corpusers.net>
 <CAFLxGvyy=73dGQqG8W6SXZah7WQZ4gJAeeHXN8opKaOuG-5yUQ@mail.gmail.com>
 <20130529094826.GD13095@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B865@CNBJMBX05.corpusers.net>
 <35FD53F367049845BC99AC72306C23D1610991B866@CNBJMBX05.corpusers.net>
 <20130530090949.GC7483@mudshark.cambridge.arm.com>
 <20130530114112.GH7483@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B86D@CNBJMBX05.corpusers.net>
 <20130531084638.GB4928@mudshark.cambridge.arm.com>
 <35FD53F367049845BC99AC72306C23D1610991B874@CNBJMBX05.corpusers.net>
 <20130531111305.GI4928@mudshark.cambridge.arm.com>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 May 2013, Will Deacon wrote:

> Hard to tell without context. You can take a look at my git tree if you
> like (I fixed it up based on Nico's comment):
> 
>   https://git.kernel.org/cgit/linux/kernel/git/will/linux.git/commit/?h=misc-patches

If you like, you may add "Reviewed-by: Nicolas Pitre <nico@linaro.org>" 
to it.


Nicolas

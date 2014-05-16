Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757581AbaEPQDF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:03:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:40104 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757425AbaEPQDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:03:03 -0400
Date: Fri, 16 May 2014 18:03:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Erik Bosman <erik@minemu.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] x86: SROP mitigation: implement signal canaries
Message-ID: <20140516160301.GH1873@two.firstfloor.org>
References: <20140515211004.GA9575@pizzadoos.com>
 <87vbt6rao3.fsf@tassilo.jf.intel.com>
 <20140515223222.GA9727@pizzadoos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140515223222.GA9727@pizzadoos.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hrmz.. FP state is aligned on a 64 byte boundary, the signal frame (separately)
> on a 16 byte-sizeof(long) boundary.  But it looks like that for 32 and 64 bit
> rt_sigreturn this means no padding :-/

There may be some unused bytes in the existing structures, perhaps not
continuous.

-Andi

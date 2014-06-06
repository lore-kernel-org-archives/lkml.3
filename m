Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbaFFORY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 10:17:24 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:33464 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507AbaFFORX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 10:17:23 -0400
Message-ID: <5391CD70.70703@gmail.com>
Date: Fri, 06 Jun 2014 10:17:20 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: regarding use of various cmpxchg* API
References: <5390F2D5.909@gatech.edu> <20140606072924.GP6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140606072924.GP6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2014 03:29 AM, Peter Zijlstra wrote:

> 
> Don't think that's useful. If you really want to go do something, try
> the annotation I suggested to get the parisc/sparc32 things correct
> again. Add the __atomic sparse address space and the store()/load()
> accessors.
> 

OK. I am not sure what you are referring to here, just started looking at the kernel again. Any pointers to this accessors thing?

--
Pranith

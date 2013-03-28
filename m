Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3C1Ffj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 01:35:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48362 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab3C1Ffh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 01:35:37 -0400
Message-ID: <5153D698.6010102@zytor.com>
Date: Wed, 27 Mar 2013 22:35:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>
CC: linux-kernel@vger.kernel.org, arnd@arndb.de, linux-arch@vger.kernel.org
Subject: Re: Generic syscall ABI support
References: <1364440182.2289.45.camel@leyfoon-vm>
In-Reply-To: <1364440182.2289.45.camel@leyfoon-vm>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/27/2013 08:09 PM, Ley Foon Tan wrote:
> Need advise regarding the generic syscall ABI support.
> 
> We are planning to upstream our Nios II kernel (arch/nios2) to mainline.
> But it doesn't support generic syscall ABI yet (It requires an updated
> Glibc port as well). 
> 
> The question is, is it a requirement for new arch to support generic
> syscall ABI when upstreaming? Can we upstream a non-generic syscall ABI
> first and migrate to generic syscall ABI in future?
> Thanks.
> 
> Regards
> LFTAN
> 

That would be extremely difficult.

In general, you should use the generic ABI for a new port unless you
have *very* strong and convincing reasons not to.

Given how long the Nios2 port has been in upstreaming (unfortunate, I
like to play with FPGAs ;) it seems worthwhile to adjust it before
pushing it.

	-hpa


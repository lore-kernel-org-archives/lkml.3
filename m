Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754657AbaKRPxp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:53:45 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:53324 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754252AbaKRPxo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:53:44 -0500
Message-ID: <546B6B65.4050005@ti.com>
Date: Tue, 18 Nov 2014 21:23:09 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Russell King <linux@arm.linux.org.uk>
CC: <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: davinci: Remove redundant casts
References: <1413903211-3143-1-git-send-email-linux@rasmusvillemoes.dk> <54468558.8040204@cogentembedded.com>
In-Reply-To: <54468558.8040204@cogentembedded.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 21 October 2014 09:40 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 10/21/2014 06:53 PM, Rasmus Villemoes wrote:
> 
>> These casts to char* are unnecessary and slightly confusing, since
>> both operands actually have type const char*.
> 
>    Both operands of what? Typecast only has 1 operand. :-)

Queuing this with this description:

"
Remove unnecessary casts to char*. Both operands of the
assignment actually have type const char*.
"

Thanks,
Sekhar

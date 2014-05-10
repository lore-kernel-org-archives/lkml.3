Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425AbaEJRPm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:15:42 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55073 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbaEJRPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:15:40 -0400
Message-ID: <536E5EB9.5060101@infradead.org>
Date: Sat, 10 May 2014 10:15:37 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: akpm@linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
CC: Richard Weinberger <richard@nod.at>
Subject: Re: mmotm 2014-05-09-16-17 uploaded (ptrace-ab.hi vs. net/core/filter.c)
References: <20140509231825.22D005A4123@corp2gmr1-2.hot.corp.google.com>
In-Reply-To: <20140509231825.22D005A4123@corp2gmr1-2.hot.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2014 04:18 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2014-05-09-16-17 has been uploaded to
> 
>    http://www.ozlabs.org/~akpm/mmotm/
> 


uml defconfig on x86_64: (also happens in linux-next)

net/core/filter.c:57:0: warning: "R8" redefined [enabled by default]
arch/x86/include/uapi/asm/ptrace-abi.h:38:0: note: this is the location of the previous definition

Same warnings for R9 and R10.

-- 
~Randy

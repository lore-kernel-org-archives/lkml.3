Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab3GWJzU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 05:55:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57575 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab3GWJzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 05:55:18 -0400
Message-ID: <51EE52BE.5080204@zytor.com>
Date: Tue, 23 Jul 2013 02:54:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Chen Gang <gang.chen@asianux.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH, re-send] Always trap on BUG()
References: <201307051738.35930.arnd@arndb.de> <20130715151612.9499c2b2ad40e88d183a4600@linux-foundation.org> <20130715222755.GY24642@n2100.arm.linux.org.uk> <51E47924.9030005@zytor.com> <20130723093628.GC19786@gmail.com>
In-Reply-To: <20130723093628.GC19786@gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2013 02:36 AM, Ingo Molnar wrote:
>>
>> Well, there are three alternatives here, right:
>>
>> 1. We can use unreachable(), which means that the compiler can assume it
>> never happens.
> 
> AFAICS this is dangerous as it loses warnings and moves execution into 
> la-la-land without any obvious sign at the C level.
> 

Extremely dangerous.

	-hpa


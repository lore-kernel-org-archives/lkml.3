Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaACXTF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 18:19:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34092 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803AbaACXTD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:19:03 -0500
Message-ID: <52C74544.4010604@zytor.com>
Date: Fri, 03 Jan 2014 15:18:28 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/boot: use .code16 instead of .code16gcc
References: <1388788242.2391.75.camel@shinybook.infradead.org>	 <52C73AD8.3080603@zytor.com> <1388790753.2391.77.camel@shinybook.infradead.org>
In-Reply-To: <1388790753.2391.77.camel@shinybook.infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/2014 03:12 PM, David Woodhouse wrote:
> On Fri, 2014-01-03 at 14:34 -0800, H. Peter Anvin wrote:
>>
>> Nice.  I would really like a gcc option "-m16" even if all it did was
>> emit .code16gcc first in any assembly file 
> 
> Is there a PR for that specific request?
> 

http://gcc.gnu.org/bugzilla/show_bug.cgi?id=59672

Just filed it.

	-hpa


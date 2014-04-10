Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbaDJTLP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:11:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55505 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753456AbaDJTLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:11:13 -0400
Message-ID: <5346ECCF.2010003@infradead.org>
Date: Thu, 10 Apr 2014 12:11:11 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jonathan Callen <jcallen@gentoo.org>
CC: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/java.txt: add Java 7 support
References: <1396237634-6634-1-git-send-email-jcallen@gentoo.org> <5345737E.4050008@infradead.org> <53465558.8090300@gentoo.org>
In-Reply-To: <53465558.8090300@gentoo.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 01:24 AM, Jonathan Callen wrote:
> On 04/09/2014 12:21 PM, Randy Dunlap wrote:
>> On 03/30/2014 08:47 PM, Jonathan Callen wrote:
>>> The sample wrapper currently fails on some Java 7 .class files.  This
>>> updates the wrapper to properly handle those files.
>>>
>>> Signed-off-by: Jonathan Callen <jcallen@gentoo.org>
>>
>> Applied.  Thanks.
>>
>> How would I test this?
>>
> 
> I have attached a hand-crafted HelloWorld.class file that fails unless this patch is applied.  This
> .class file intentionally has extra entries in its constant pool that are not used by Java, but the
> file does pass validation.
> 
> A complete disassembly of that file, showing the purpose of each byte, is attached as HelloWorld.jj.

Thanks much.



-- 
~Randy

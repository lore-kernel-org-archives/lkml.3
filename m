Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965568Ab3DTB4k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:56:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29255 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470Ab3DTB4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:56:39 -0400
X-Spam-Score: -100.8
Message-ID: <5171F57B.7090305@asianux.com>
Date: Sat, 20 Apr 2013 09:55:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Christopher Covington <cov@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, duplicate definition
 of early_console
References: <5152DB83.8080703@asianux.com> <516E66F9.9070904@asianux.com> <51712213.4060607@asianux.com> <201304191415.31986.arnd@arndb.de>
In-Reply-To: <201304191415.31986.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月19日 20:15, Arnd Bergmann wrote:
> On Friday 19 April 2013, Chen Gang wrote:
>> >   when compiling with allmodconfig.
>> >     early_console is already defined as an extern global pointer.
>> > 
>> >   need let it point to the object which we intend to (like ARM32 done).
>> > 
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> 
> 

  thanks

-- 
Chen Gang

Asianux Corporation

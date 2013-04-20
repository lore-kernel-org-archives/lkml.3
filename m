Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573Ab3DTBzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Apr 2013 21:55:22 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29068 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965470Ab3DTBzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Apr 2013 21:55:21 -0400
X-Spam-Score: -100.8
Message-ID: <5171F55F.5080501@asianux.com>
Date: Sat, 20 Apr 2013 09:54:39 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Christopher Covington <cov@codeaurora.org>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM64: kernel: compiling issue, duplicate definition
 of early_console
References: <5152DB83.8080703@asianux.com> <20130327115509.GA1603@MacBook-Pro.local> <5152DFF1.2090000@asianux.com> <515BE49C.8040601@asianux.com> <515C14FD.4040703@codeaurora.org> <515C2808.70406@asianux.com> <516E66F9.9070904@asianux.com> <51712213.4060607@asianux.com> <20130419123150.GA18443@arm.com>
In-Reply-To: <20130419123150.GA18443@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月19日 20:31, Catalin Marinas wrote:
> On Fri, Apr 19, 2013 at 11:53:07AM +0100, Chen Gang wrote:
>>   when compiling with allmodconfig.
>>     early_console is already defined as an extern global pointer.
>>
>>   need let it point to the object which we intend to (like ARM32 done).
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Thanks for the patch.
> 

  :-)

-- 
Chen Gang

Asianux Corporation

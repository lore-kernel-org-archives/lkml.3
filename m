Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761013Ab3DCNBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 09:01:32 -0400
Received: from intranet.asianux.com ([58.214.24.6]:29804 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab3DCNBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 09:01:31 -0400
X-Spam-Score: -100.7
Message-ID: <515C2808.70406@asianux.com>
Date: Wed, 03 Apr 2013 21:00:56 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Christopher Covington <cov@codeaurora.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        "anup.patel@linaro.org" <anup.patel@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Suggestion] ARM64:kernel: compiling issue for early_console.
References: <5152DB83.8080703@asianux.com> <20130327115509.GA1603@MacBook-Pro.local> <5152DFF1.2090000@asianux.com> <515BE49C.8040601@asianux.com> <515C14FD.4040703@codeaurora.org>
In-Reply-To: <515C14FD.4040703@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013年04月03日 19:39, Christopher Covington wrote:
> Maybe somebody else does have a fix, but Catalin mentioned he was going on
> vacation for two weeks on March 28th in "[GIT PULL] Preparatory GIC patches
> for arm64 support".
> 
  ok, I can wait.

>> >   if really no one fix it within this week, I should try (since I find it).
> I'm sure a fix would be appreciated.
> 

  ok, thanks. I prefer to wait (at least for the end of Catalin's vacation).


>> > On 2013年03月27日 20:02, Chen Gang wrote:
>>> >> On 2013年03月27日 19:55, Catalin Marinas wrote:
>>>> >>>
>>>> >>> I saw some patches from tglx on unifying the various early printk
>>>> >>> implementations, though not sure whether it's those patches causing it
>>>> >>> (in which case arm64 needs to be updated as well).
> I looked briefly and wasn't able to find this patchset.

  ok, thank for your results.


-- 
Chen Gang

Asianux Corporation

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756026AbbAGI5a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 03:57:30 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46622 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbbAGI53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 03:57:29 -0500
Message-ID: <54ACF4FA.2080309@linaro.org>
Date: Wed, 07 Jan 2015 08:57:30 +0000
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kiran Raparthy <kiran.kumar@linaro.org>, linux-kernel@vger.kernel.org,
        Colin Cross <ccross@android.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>
Subject: Re: [RFC v4] debug: prevent entering debug mode on panic/exception.
References: <1419338309-16729-1-git-send-email-kiran.kumar@linaro.org>	<20150105161412.44f53313e1d771dc9f968264@linux-foundation.org>	<54ABFFD3.2020305@linaro.org> <20150106131608.a756b9e8aaf8c496099a5736@linux-foundation.org>
In-Reply-To: <20150106131608.a756b9e8aaf8c496099a5736@linux-foundation.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/15 21:16, Andrew Morton wrote:
> On Tue, 06 Jan 2015 15:31:31 +0000 Daniel Thompson <daniel.thompson@linaro.org> wrote:
> 
>> On 06/01/15 00:14, Andrew Morton wrote:
>>> We appear to have forgotten to document panic_timeout.  Sigh.
>>
>> I knew I'd seen it somewhere...
>>
>> Once its been sysctlised it ends up called "panic":
>>   https://www.kernel.org/doc/Documentation/sysctl/kernel.txt
> 
> Confused.  That file doesn't mention panic_timeout.  But it is the
> place where panic_timeout can be described.

The sysctl is called "panic" (as is the closely related kernel parameter)

The name panic_timeout is used only for the C symbol presumably because
panic was already used for something else...


Daniel.


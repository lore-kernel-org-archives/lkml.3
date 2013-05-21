Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754486Ab3EUNNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 09:13:17 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:34235 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab3EUNNQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 09:13:16 -0400
Message-ID: <519B7298.1090109@synopsys.com>
Date: Tue, 21 May 2013 18:41:52 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARC MM Bug Fix
References: <1369140259-30501-1-git-send-email-vgupta@synopsys.com> <519B6DA7.7000305@synopsys.com>
In-Reply-To: <519B6DA7.7000305@synopsys.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.228]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2013 06:20 PM, Vineet Gupta wrote:
> On 05/21/2013 06:14 PM, Vineet Gupta wrote:
>> Hi Linus,
>>
>> I have a ARC MM bug fix, and it seems the best way to CC stable explicitly, is
>> to send a patch to them (and hence you as well - as opposed to regular
>> pull-req). OK with you ?
> 
> Damn ! Despite the noise, the CC to stable didn't go thru - I missed < > around
> the email address perhaps.
> 
> -Vineet
> 

Please ignore the whole thread - bad day it seems - while the patch fixes the
issue with no apparent regressions it introduces a bit of bogosity in TLB Miss
handlers. I'll respin/re-test and send this via  regular pull request and notify
stable explicitly.

Sorry once again for the noise.

Thx,
-Vineet

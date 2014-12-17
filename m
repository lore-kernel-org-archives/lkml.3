Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751456AbaLQNEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 08:04:01 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53867 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaLQND7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 08:03:59 -0500
Message-ID: <54917F3C.4090007@acm.org>
Date: Wed, 17 Dec 2014 07:03:56 -0600
From: Corey Minyard <minyard@acm.org>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Corey Minyard <cminyard@mvista.com>
CC: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>, Huang Ying <ying.huang@intel.com>
Subject: Re: [LKP] [ipmi] BUG: key ffff880fcfc51ed0 not in .data!
References: <CAADnVQLerROn=H=w0T29wt-wO=SbHaggrso_B7aGCajrAJ3TvA@mail.gmail.com>
In-Reply-To: <CAADnVQLerROn=H=w0T29wt-wO=SbHaggrso_B7aGCajrAJ3TvA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 07:05 PM, Alexei Starovoitov wrote:
> On Tue, Dec 16, 2014 at 5:08 AM, Corey Minyard <cminyard@mvista.com> wrote:
>> Yes, should be fixed by:
>>
>> commit 693726299ba87a6e267993806bc1320a266e5c5e
>> Author: Corey Minyard <cminyard@mvista.com>
>> Date:   Fri Dec 12 19:06:07 2014 -0600
>>
>>     ipmi: Finish cleanup of BMC attributes
>>
>> which should be in linux-next now.  I was able to reproduce and verify
>> that this fixed it.  I've verified that the branch is correct in the
>> repository.
> thanks. cleared the warning for me as well:
> Tested-by: Alexei Starovoitov <ast@plumgrid.com>
>
> Are you planning to send a pull request
> before the merge window is over or for rc2 ?

Yes, I believe I will.  I was planning to wait until it was in
linux-next for a little while, but a "Tested-by" from you and Huang Ying
would give me more confidence :).

-corey

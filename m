Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751659Ab3JVIxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:53:10 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:49396 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab3JVIxH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:53:07 -0400
X-AuditID: 85900ec0-d0927b9000001514-45-52663cf096a2
Message-ID: <52663CFA.9020901@hitachi.com>
Date: Tue, 22 Oct 2013 17:53:14 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH V2 0/5] trace-cmd: Support the feature recording trace
 data of guests on the host
References: <20130913020627.28927.69090.stgit@yunodevel> <20131018110616.01a26af6@gandalf.local.home>
In-Reply-To: <20131018110616.01a26af6@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

(2013/10/19 0:06), Steven Rostedt wrote:
> On Fri, 13 Sep 2013 11:06:27 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>> Hi Steven,
>>
>> This is a v2 patch set for realizing a part of "Integrated trace" feature which
>> is a trace merging system for a virtualization environment. Currently, trace-cmd
>> does not have following features yet:
>>
>> a) Server and client for a virtualization environment
>> b) Structured message platform between guests and host
>> c) Agent feature of a client
>> d) Merge feature of trace data of multiple guests and host in chronological
>>     order
>>
>
> Hi Yoshihiro,
>
> I do like your patch set, but I was thinking as this is becoming a new
> ABI between the client and the server, I really want to spend a lot
> more time looking at this before I pull it.
>
> I'll be traveling again on Monday for 10 days (going to Kernel Summit
> than the RT summit), and I'll try to review it more during my trip. But
> even then, I really want to make sure the communication is robust. I
> hate to have a "V3" and then need to support two older versions.

Sure, I agree with you:)
Thank you for spending a lot of time on reviewing this patch set.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



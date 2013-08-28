Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab3H1Lbg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 07:31:36 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37138 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675Ab3H1Lbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 07:31:35 -0400
X-AuditID: 85900ec0-d0927b9000001514-30-521ddf953729
Message-ID: <521DDF8C.8060803@hitachi.com>
Date: Wed, 28 Aug 2013 20:31:24 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [RFC PATCH 00/11] trace-cmd: Support the feature recording
 trace data of guests on the host
References: <20130819094620.26597.79499.stgit@yunodevel> <20130820120006.1a4118c5@gandalf.local.home> <521AB37E.4050800@hitachi.com> <20130826102229.6e0129fe@gandalf.local.home> <521C5E46.9060704@hitachi.com> <20130827090045.4b392273@gandalf.local.home>
In-Reply-To: <20130827090045.4b392273@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/08/27 22:00), Steven Rostedt wrote:
> On Tue, 27 Aug 2013 17:07:34 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
> et, but I'd like to
>> add such feature to fix host/guest clock difference in the next series.
>> TSC offset values can be gotten as write_tsc_offset trace event from
>> kernel-3.11. (see https://lkml.org/lkml/2013/6/12/72)
>> How do you think about this merging feature?
>
> If it's already been merged, then sure, we can use it.

Great. I'll implement the feature for trace-cmd.

Thank you for your a lot of comments.

Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



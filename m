Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbaFBA2j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 20:28:39 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58630 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751879AbaFBA2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 20:28:36 -0400
X-AuditID: 85900ec0-d3b2cb9000001514-f2-538bc5313a29
Message-ID: <538BC530.3040606@hitachi.com>
Date: Mon, 02 Jun 2014 09:28:32 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>, linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Ingo Molnar <mingo@redhat.com>, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH V2 2/2] ftrace: Introduce nr_saved_cmdlines I/F
References: <20140220084428.3839.59555.stgit@yunodevel> <20140220084433.3839.49609.stgit@yunodevel> <20140530100223.150a1ea2@gandalf.local.home> <20140530130841.57b3042f@gandalf.local.home>
In-Reply-To: <20140530130841.57b3042f@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

Thank you for your review and fixing my patch.

(2014/05/31 2:08), Steven Rostedt wrote:
> On Fri, 30 May 2014 10:02:23 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
>
>> This last part conflicts with my current 3.16 queue. You can see how it
>> does in my for-next repo. But I'll be pushing my latest with the
>> updates I mentioned above soon and will let you know where to get them.
>
> I just pushed my updates to my repo, which includes your first patch
> plus a fix. This may still rebase, I only solidify my "for-next"
> branch. But if you rewrite your patch against this branch with my
> updates, then I can take it and test it for 3.16. Still have one week
> left, but the earlier the better.

OK, I understood. I'll fix my 2nd patch based on your review, and
I'll resend the patch as soon as possible.

Thank you,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



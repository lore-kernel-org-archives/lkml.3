Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152AbaGAA6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:58:54 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:34954 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840AbaGAA6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:58:52 -0400
Message-ID: <53B207C3.9040109@hitachi.com>
Date: Tue, 01 Jul 2014 09:58:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-arch@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Josh Poimboeuf <notifications@github.com>
Subject: Re: Re: [RFA][PATCH 00/27] ftrace: Remove ftrace_start/stop()
 and friends
References: <20140626165221.736847419@goodmis.org> <53B0D5C4.8000909@hitachi.com> <20140630101632.00274c9d@gandalf.local.home>
In-Reply-To: <20140630101632.00274c9d@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2014/06/30 23:16), Steven Rostedt wrote:
> On Mon, 30 Jun 2014 12:13:08 +0900
> Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> Uh, from the same reason, I must list it in the kprobe blacklist too...
> 
> Ah yes!
> 
>>
>> BTW, as far as I can review, x86 and generic parts of the series seems
>> OK to me. :)
>>
> 
> Can you post a Acked-by or Reviewed-by then?

Yeah, Please feel free to add my Reviewed-by to 1-5, 11-16, and 27 :)

Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



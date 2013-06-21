Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758060Ab3FUCZV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:25:21 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:58940 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757600Ab3FUCZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:25:19 -0400
Message-ID: <51C3B98C.3090405@hitachi.com>
Date: Fri, 21 Jun 2013 11:25:16 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] tracing/kprobes: perf_trace_buf_*() optimization
 + cleanups
References: <20130620173748.GA13133@redhat.com> <1371753773.18733.102.camel@gandalf.local.home>
In-Reply-To: <1371753773.18733.102.camel@gandalf.local.home>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/06/21 3:42), Steven Rostedt wrote:
> On Thu, 2013-06-20 at 19:37 +0200, Oleg Nesterov wrote:
>> Steven,
>>
>> Please consider this series for inclusion. It doesn't depend on
>> other changes we are discussing.
>>
>> Only cosmetic changes since v1, everything was acked by Masami.
>>
> 
> 
> Not that I don't trust you :-)
> 
> But Masami, can you Ack all these patches one more time. I like to have
> the Acked-by, a direct reply to the patches I pull. It's also fine to
> reply to this email with "All patches in this series: Acked-by: ... " So
> you don't need to reply to each patch individually.

Sure, all patches are fine for me :)

All patches in this series: Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Thank you!

-- 
Masami HIRAMATSU
IT Management Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



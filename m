Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752036Ab3JVIxx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:53:53 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:50012 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751826Ab3JVIxw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:53:52 -0400
X-AuditID: 85900ec0-cff26b9000001514-4a-52663d1e6b87
Message-ID: <52663D27.5000101@hitachi.com>
Date: Tue, 22 Oct 2013 17:53:59 +0900
From: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
User-Agent: Mozilla/5.0 (Windows NT 5.2; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com
Subject: Re: Re: [PATCH V2 2/5] trace-cmd: Apply the trace-msg protocol
 for communication between a server and clients
References: <20130913020627.28927.69090.stgit@yunodevel> <20130913020632.28927.18549.stgit@yunodevel> <20131017221953.4bc6d43e@gandalf.local.home>
In-Reply-To: <20131017221953.4bc6d43e@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2013/10/18 11:19), Steven Rostedt wrote:
> On Fri, 13 Sep 2013 11:06:32 +0900
> Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com> wrote:
>
>
>> diff --git a/trace-msg.c b/trace-msg.c
>> new file mode 100644
>> index 0000000..cf82ff6
>> --- /dev/null
>> +++ b/trace-msg.c
>> @@ -0,0 +1,683 @@
>> +/*
>> + * trace-msg.c : define message protocol for communication between clients and
>> + *               a server
>> + *
>> + * Copyright (C) 2013 Hitachi, Ltd.
>> + * Created by Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
>> + *
>> + * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> + *
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; version 2 of the License (not later!)
>> + *
>
> BTW, as this can be used in a library, would be OK with re-licensing
> this as the LGPL v2.1?
>
> I try to keep all the helper C files as LGPL and the program files as
> GPL. I would have made all of trace-cmd LGPL, but there was some code I
> needed that was GPL, and I could only use it if I had the program as
> GPL code.

No problem.
When I resubmit this patch set, I'll change this license.

Thanks,
Yoshihiro YUNOMAE

-- 
Yoshihiro YUNOMAE
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: yoshihiro.yunomae.ez@hitachi.com



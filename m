Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754466Ab3FKBMp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 21:12:45 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21712 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472Ab3FKBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 21:12:44 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=lzW3C4oBqRkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=66bpkragbbcA:10 a=LWV00BkUyhvvycwt9-gA:9 a=QEXdDO2ut3YA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370913163.9844.167.camel@gandalf.local.home>
Subject: Re: Re: [PATCH -tip] ftrace: Fix outputting formats of x86-tsc and
 counter when use trace_clock
From: Steven Rostedt <rostedt@goodmis.org>
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Mon, 10 Jun 2013 21:12:43 -0400
In-Reply-To: <51B672D4.9050003@hitachi.com>
References: <20130423013239.22334.7394.stgit@yunodevel>
	 <51886484.7060203@hitachi.com> <51B672D4.9050003@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-06-11 at 09:44 +0900, Yoshihiro YUNOMAE wrote:
> Hi Steven,
> 
> Would you review this bugfix patch?

Ah, thanks for the reminder. This got pushed down on my todo list. I'll
take a look at it tonight.

-- Steve

> 
> Thanks,
> Yoshihiro YUNOMAE
> 



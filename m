Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385AbaIVIJ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:09:57 -0400
Received: from sestofw01.enea.se ([192.36.1.252]:27572 "HELO mx-3.enea.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752485AbaIVIJz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:09:55 -0400
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2014 04:09:55 EDT
Date: Mon, 22 Sep 2014 10:04:23 +0200
From: Mats Liljegren <mats.liljegren@enea.com>
To: duzhiping <duzhiping.du@huawei.com>
CC: <rostedt@goodmis.org>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>,
        <wangnan0@huawei.com>
Subject: Re: itrace: An interrupts tracing tool
Message-ID: <20140922100423.410e3644@mats-desktop>
In-Reply-To: <541F990F.7030806@huawei.com>
References: <541F990F.7030806@huawei.com>
Organization: Enea
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Sep 2014 11:35:43 +0800
duzhiping <duzhiping.du@huawei.com> wrote:

>   Many functions depends on interrupts in Linux system, when the
> interrupts occur an error, it may cause fatal problem.
> 
>   Then, we should record their trace when interrupts in and out. The
> recorded information could help us analyze interrupts errors.
> 
>   Itrace is such an interrupts trace tool we have developed, it
> provides config interface and trace information through "procfs".
> 
>   Do you think it has the value to upstream?

Where can I look at the code?

What makes it different from existing tools, e.g. ftrace?

/Mats

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463Ab3FMBtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:49:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:9934 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab3FMBt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:49:28 -0400
Message-ID: <51B9250F.9050704@huawei.com>
Date: Thu, 13 Jun 2013 09:49:03 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Subject: Re: [PATCH 3.0-stable 1/2] tracing: Fix possible NULL pointer dereferences
References: <51B1A131.9090206@huawei.com> <20130610211350.GE1602@kroah.com>
In-Reply-To: <20130610211350.GE1602@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/6/11 5:13, Greg Kroah-Hartman wrote:
> On Fri, Jun 07, 2013 at 05:00:33PM +0800, Li Zefan wrote:
>> commit 6a76f8c0ab19f215af2a3442870eeb5f0e81998d upstream.
>>
>> Currently set_ftrace_pid and set_graph_function files use seq_lseek
>> for their fops.  However seq_open() is called only for FMODE_READ in
>> the fops->open() so that if an user tries to seek one of those file
>> when she open it for writing, it sees NULL seq_file and then panic.
> 
> You lost the original authorship of this patch, which is a very bad
> thing to do.
> 

Oops, my bad.

> Ugh, time to edit emails by hand, not my favorite pasttime, someone owes
> me a drink...
> 

Sure, maybe at Plumber. ;)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521Ab3GCECw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 00:02:52 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:4748 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab3GCECv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 00:02:51 -0400
Message-ID: <51D3A254.6050202@huawei.com>
Date: Wed, 3 Jul 2013 12:02:28 +0800
From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: <fweisbec@gmail.com>, <mingo@redhat.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 01/12] tracing: move trace_array definition into include/linux/trace_array.h
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>  <1365564393-10972-2-git-send-email-jovi.zhangwei@huawei.com> <1372807191.22688.76.camel@gandalf.local.home>
In-Reply-To: <1372807191.22688.76.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.66.58.241]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/3 7:19, Steven Rostedt wrote:
> On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
>> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
>>
>> Prepare for expose event tracing infrastructure.
>> (struct trace_array shall be use by external modules)
>>
> 
> What module is going to be using this?
> 
> -- Steve
> 
Please ignore this patch, the reason was posted in another thread reply,
sorry for this.

jovi



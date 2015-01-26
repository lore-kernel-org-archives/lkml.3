Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789AbbAZLL6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 06:11:58 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:30000 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754150AbbAZLL4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 06:11:56 -0500
Message-ID: <54C620EB.5060806@huawei.com>
Date: Mon, 26 Jan 2015 19:11:39 +0800
From: Wang Nan <wangnan0@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Jiri Olsa <jolsa@redhat.com>,
        =?ISO-8859-1?Q?J=E9r=E9mie_Galarneau?= 
	<jeremie.galarneau@efficios.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Li Zefan <lizefan@huawei.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] perf: convert: fix duplicate field names and
 avoid reserved keywords.
References: <1421904958-24106-1-git-send-email-wangnan0@huawei.com> <1421905003-24242-1-git-send-email-wangnan0@huawei.com> <20150122132734.GB2473@krava.brq.redhat.com> <54C1AAA1.4000300@huawei.com> <CA+jJMxsjh=H+f3z+cnJ6tFbmyrD-ArGSe7agVVvc4tird8MdHw@mail.gmail.com> <20150124163925.GD17627@krava.brq.redhat.com>
In-Reply-To: <20150124163925.GD17627@krava.brq.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.111.69.129]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.54C620FA.00C5,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 31ef6c7f702578cc635b699ac5cb7d89
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I posted a new series of patches for this problem. I open another thread to avoid
disorder this thread. Please see:

https://lkml.org/lkml/2015/1/26/198

Thank you.

On 2015/1/25 0:39, Jiri Olsa wrote:
> On Fri, Jan 23, 2015 at 05:40:02PM -0500, Jérémie Galarneau wrote:
> 
> SNIP
> 
>>> bt_ctf_clock_create() with the checked name and then free it. However, it is hacky
>>> and I think you won't like it.
>>
>> The prospect of seeing that code has convinced me to introduce
>> int bt_ctf_validate_identifier(const char *identifier);
>>
>> commit 654c1444b546fd79b209288b93ed4e87d9bb8a2b
>> Author: Jérémie Galarneau <jeremie.galarneau@efficios.com>
>> Date:   Fri Jan 23 16:24:52 2015 -0500
>>
>>     Add utility function to validate CTF identifiers
>>
>>     Introduces bt_ctf_validate_identifier() which validates a given
>>     identifier against the list of CTF reserved keywords.
>>
>>     This function may evolve to perform additional validity checks in
>>     the future as the CTF specification moves forward.
>>
>>     Acked-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
>>     Signed-off-by: Jérémie Galarneau <jeremie.galarneau@efficios.com>
>>
>>
>> Does that take care of the problem?
> 
> seems good to me, thanks
> 
> jirka
> 



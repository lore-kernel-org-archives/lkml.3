Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab3GBXTy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 19:19:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22413 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3GBXTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 19:19:52 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=nUu-TyO2RPcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=eJBYe9u5HvsA:10 a=i0EeH86SAAAA:8 a=9JWOj2uIYgInK8W6ojUA:9 a=QEXdDO2ut3YA:10 a=hPjdaMEvmhQA:10 a=sHycelHf8_oA:10 a=QJXD6YIqSi4A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1372807191.22688.76.camel@gandalf.local.home>
Subject: Re: [PATCH v3 01/12] tracing: move trace_array definition into
 include/linux/trace_array.h
From: Steven Rostedt <rostedt@goodmis.org>
To: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Tue, 02 Jul 2013 19:19:51 -0400
In-Reply-To: <1365564393-10972-2-git-send-email-jovi.zhangwei@huawei.com>
References: <1365564393-10972-1-git-send-email-jovi.zhangwei@huawei.com>
	 <1365564393-10972-2-git-send-email-jovi.zhangwei@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-04-10 at 11:26 +0800, zhangwei(Jovi) wrote:
> From: "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>
> 
> Prepare for expose event tracing infrastructure.
> (struct trace_array shall be use by external modules)
> 

What module is going to be using this?

-- Steve



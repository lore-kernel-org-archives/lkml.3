Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaAHJJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 04:09:38 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:65216 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbaAHJJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 04:09:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAKohpomKH=vQiMKBuDOPyg3+djmG+4chkjruihMQChz5gJ+yzw@mail.gmail.com>
References: <CAKohpom5JmFamPpOsyPRqXNAqXu6VF_t0zXXhT90MCMutp5FgQ@mail.gmail.com>
	<20131224084801.57439ca2@gandalf.local.home>
	<CAKohpom3haZ+LSdOtAjCM7x2C4YOC_a31OMPeE05ung4MAR68g@mail.gmail.com>
	<20131226152913.GB15303@localhost.localdomain>
	<CAKohpokMJWoOmqVZ2hp0AfvTerxqenXM=AFrFz5cJLJaFNcGqw@mail.gmail.com>
	<CAKohpomKH=vQiMKBuDOPyg3+djmG+4chkjruihMQChz5gJ+yzw@mail.gmail.com>
Date: Wed, 8 Jan 2014 14:39:30 +0530
Message-ID: <CAKohpo=LoJFLS93FEW1XZW5qWmSZTmBjS5GauOkaw+GW02PseA@mail.gmail.com>
Subject: Re: [Query]: trace-cmd crashing with '-e syscalls' on 3.13-rc1
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linaro Networking <linaro-networking@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7 January 2014 13:20, Viresh Kumar <viresh.kumar@linaro.org> wrote:
> Ping!!

Two things:
- I didn't had CONFIG_FTRACE_SYSCALLS enabled earlier
- On latest linux,

b4a839b Add linux-next specific files for 20140106

I don't see that crash anymore with our without
CONFIG_FTRACE_SYSCALLS enabled.

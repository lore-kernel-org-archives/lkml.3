Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756978Ab3BVOZN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 09:25:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10086 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755889Ab3BVOZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 09:25:10 -0500
Message-ID: <51277F77.2090908@redhat.com>
Date: Fri, 22 Feb 2013 15:23:51 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: u3557@dialix.com.au
CC: Amnon Shiloh <u3557@miso.sublimeip.com>,
        Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Pedro Alves <palves@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: Re: prctl(PR_SET_MM)
References: <20130219062531.4F317592076@miso.sublimeip.com>
In-Reply-To: <20130219062531.4F317592076@miso.sublimeip.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2013 07:25 AM, Amnon Shiloh wrote:
> Steven Rostedt wrote:
> 
>> If only you, or a few people are using it (ie. distros don't see a
>> need), then it will be up to you to make the changes.
> 
> I believe that this functionality is of a general nature and is needed
> by many, not only by myself and by the CRIU group, but by all user-level
> software packages, past present and future, that provide some form or
> another of reconstructing a Linux process.

That's what "RESTORE" part of CONFIG_CHECKPOINT_RESTORE refers to:
the ability to restore (reconstruct) a process.

If you want to be able to restore a process, you need RESTORE
feature. It's that simple.

Why do you want yet another config option for it?
What's the problem if you simply enable CONFIG_CHECKPOINT_RESTORE?

The only problem I can imagine is "CONFIG_CHECKPOINT_RESTORE
enables too many things I don't need".

Frankly, I find it not very likely, unless you are planning
on working on resource-constrained machines (like mobile phone).

-- 
vda



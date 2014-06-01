Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaFAPqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 11:46:54 -0400
Received: from 78-32-181-23.static.enta.net ([78.32.181.23]:48373 "EHLO
	mail.linicks.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752250AbaFAPqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 11:46:53 -0400
Message-ID: <538B4AEC.7010108@linicks.net>
Date: Sun, 01 Jun 2014 16:46:52 +0100
From: Nick Warne <nick@linicks.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.14.5
References: <538B16C8.8090900@linicks.net>
In-Reply-To: <538B16C8.8090900@linicks.net>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/14 13:04, Nick Warne wrote:
> I am getting hundreds of the same build warnings on this release -
> usually I get none - typical warnings:
>
> include/linux/sched.h:1691: warning: ‘pid_alive’ declared inline after
> being called
> include/linux/sched.h:1691: warning: previous declaration of ‘pid_alive’
> was here
>
> Info:
>
> Machine AMD64
> gcc version 4.2.4
>
> Any more info required please CC me.

OK, revisiting this between decorating, changing line 1691 in 
include/linux/sched.h to reflect 'inline':

from:
static int pid_alive(const struct task_struct *p);

to:
static inline int pid_alive(const struct task_struct *p);

stops GCC yelling at me.

Nick
-- 
"A bug in the code is worth two in the documentation."
FSF Associate Member 5508
http://linicks.net/
http://pi.linicks.net/

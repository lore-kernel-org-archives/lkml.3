Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751207AbaJDRCo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 13:02:44 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:49506 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750920AbaJDRCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 13:02:43 -0400
MIME-Version: 1.0
In-Reply-To: <20141004105653.GK5015@linux.vnet.ibm.com>
References: <1412307228-14001-1-git-send-email-bobby.prani@gmail.com> <20141004105653.GK5015@linux.vnet.ibm.com>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Sat, 4 Oct 2014 13:02:12 -0400
Message-ID: <CAJhHMCDdOdOXHAdBShUkmVqCa_Sb2dcdS0W=r4W80KSNPb2XOA@mail.gmail.com>
Subject: Re: [PATCH] rcutorture: Remove stale test configurations
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-04 6:56 GMT-04:00 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> On Thu, Oct 02, 2014 at 11:33:48PM -0400, Pranith Kumar wrote:
>> Remove rcutorture configuration files which are no longer necessary.
>>
>> Signed-off-by: Pranith Kumar <bobby.prani@gmail.com>
>
> Queued for 3.19, thank you!
>
> The --kversion argument to the .../rcutorture/bin/kvm.sh script is
> not obsolete.  Would you be willing to remove it along with the
> "kversion" shell variable that it controls?
>

Sure, I will remove this and send you a patch.

Thanks!
--
Pranith

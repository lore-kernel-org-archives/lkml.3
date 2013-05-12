Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab3ELPzP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 11:55:15 -0400
Received: from canardo.mork.no ([148.122.252.1]:40510 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754022Ab3ELPzO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 11:55:14 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: paulmck@linux.vnet.ibm.com
Cc: Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org
Subject: Re: [v3.10-rc1] WARNING: at kernel/rcutree.c:502
Organization: m
References: <87ip2opntp.fsf@nemi.mork.no>
	<20130512113905.GH3648@linux.vnet.ibm.com>
Date: Sun, 12 May 2013 17:55:00 +0200
In-Reply-To: <20130512113905.GH3648@linux.vnet.ibm.com> (Paul E. McKenney's
	message of "Sun, 12 May 2013 04:39:05 -0700")
Message-ID: <87li7kp50r.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> writes:
> On Sun, May 12, 2013 at 11:08:50AM +0200, Bjørn Mork wrote:
>> Hello,
>> 
>> got the splat below when running powertop on plain v3.10-rc1
>> (i.e. without my previously mentioned revert patch or any other extra
>> patches).  Config attached.
>
> OK, it looks like you have context-tracking enabled, so you might be
> hitting a bug that Steven Rostedt found a few days ago.  Could you
> please try out his fix below?

Thanks for the quick reply, but I'm afraid that patch had no effect on
the warning I got. It's still there.


Bjørn

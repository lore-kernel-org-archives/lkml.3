Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760610Ab3DIELh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:11:37 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34904 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab3DIELg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:11:36 -0400
MIME-Version: 1.0
In-Reply-To: <1365440381.25498.22.camel@gandalf.local.home>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<147bfb5aa81790f94df75858bf20570cbacc9dca.1364740180.git.viresh.kumar@linaro.org>
	<CAP245DV-4d4hRGCnKUtyVV1ycHuYF4dKwh568kvHfKHdJR3xpw@mail.gmail.com>
	<CAKohponXTYSdmk71DNYsYtwU9GEYwnGcj-_wjLEZfxvEhzPWWQ@mail.gmail.com>
	<1365440381.25498.22.camel@gandalf.local.home>
Date: Tue, 9 Apr 2013 09:41:35 +0530
Message-ID: <CAKohpok7cmTkByG5Ki6bGUxJ-zbFCwT=M3ac=gT2jSktza79RQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/4] workqueue: Add system wide system_freezable_unbound_wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>, Tejun Heo <tj@kernel.org>,
        axboe@kernel.dk, Robin Randhawa <robin.randhawa@arm.com>,
        linux-rt-users@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steve Bannister <Steve.Bannister@arm.com>, airlied@redhat.com,
        Arvind Chauhan <arvind.chauhan@arm.com>, mingo@redhat.com,
        davem@davemloft.net,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2013 22:29, Steven Rostedt <rostedt@goodmis.org> wrote:
> Looks like Amit was left off the patch 0, and missed the power savings
> explanation that you did there. Perhaps you should have included that in
> each patch change log.

He isn't supposed to miss any of my emails, he is my manager :)

Don't know if change log of all patches require those details..

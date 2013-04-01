Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab3DAFZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 01:25:39 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:34260 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933Ab3DAFZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 01:25:38 -0400
MIME-Version: 1.0
In-Reply-To: <CAP245DV-4d4hRGCnKUtyVV1ycHuYF4dKwh568kvHfKHdJR3xpw@mail.gmail.com>
References: <cover.1364740180.git.viresh.kumar@linaro.org>
	<147bfb5aa81790f94df75858bf20570cbacc9dca.1364740180.git.viresh.kumar@linaro.org>
	<CAP245DV-4d4hRGCnKUtyVV1ycHuYF4dKwh568kvHfKHdJR3xpw@mail.gmail.com>
Date: Mon, 1 Apr 2013 10:55:37 +0530
Message-ID: <CAKohponXTYSdmk71DNYsYtwU9GEYwnGcj-_wjLEZfxvEhzPWWQ@mail.gmail.com>
Subject: Re: [PATCH V4 1/4] workqueue: Add system wide system_freezable_unbound_wq
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Tejun Heo <tj@kernel.org>, axboe@kernel.dk,
        Robin Randhawa <robin.randhawa@arm.com>,
        linux-rt-users@vger.kernel.org, Patch Tracking <patches@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Steve Bannister <Steve.Bannister@arm.com>, airlied@redhat.com,
        Arvind Chauhan <arvind.chauhan@arm.com>, mingo@redhat.com,
        davem@davemloft.net,
        Charles Garcia-Tobin <charles.garcia-tobin@arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 April 2013 10:50, Amit Kucheria <amit.kucheria@linaro.org> wrote:
> On Sun, Mar 31, 2013 at 8:01 PM, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>> This patch adds system wide system_freezable_unbound_wq which will be used by
>> code that currently uses system_freezable_wq and can be moved to unbound
>> workqueues.
>
> _Why_ do i need this change?

Block layer uses system_freezable_wq for some work and to migrate them to a
UNBOUND wq it was required. Sorry if it is yet not clear.

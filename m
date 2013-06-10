Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752318Ab3FJNdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 09:33:31 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35903 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab3FJNda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 09:33:30 -0400
MIME-Version: 1.0
In-Reply-To: <f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org>
References: <cover.1370861520.git.viresh.kumar@linaro.org>
	<f4753a1730051341003ad2ad29a3229c7356678e.1370861520.git.viresh.kumar@linaro.org>
Date: Mon, 10 Jun 2013 19:03:30 +0530
Message-ID: <CAKohpo=Aa99dtkh37cD-W1YtSWTKt4Bbc2c2aVP_Lpko7xPj+A@mail.gmail.com>
Subject: Re: [PATCH 2/3] sched: don't sd->child to NULL when it is already NULL
From: Viresh Kumar <viresh.kumar@linaro.org>
To: mingo@redhat.com, peterz@infradead.org
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        linux-kernel@vger.kernel.org, robin.randhawa@arm.com,
        Steve.Bannister@arm.com, Liviu.Dudau@arm.com,
        charles.garcia-tobin@arm.com, arvind.chauhan@arm.com,
        Viresh Kumar <viresh.kumar@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 June 2013 16:27, Viresh Kumar <viresh.kumar@linaro.org> wrote:

Yes subject should be: sched: don't set sd->child to NULL when it is
already NULL

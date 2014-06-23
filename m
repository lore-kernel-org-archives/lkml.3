Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752429AbaFWIc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 04:32:27 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:58014 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbaFWIc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 04:32:26 -0400
MIME-Version: 1.0
In-Reply-To: <53A7E357.5040800@intel.com>
References: <53A7E357.5040800@intel.com>
Date: Mon, 23 Jun 2014 14:02:25 +0530
Message-ID: <CAKohpomtHuXP0Q9QnWvJj1d2O=AewMR+nVNE3N_KFJkMpcCHYA@mail.gmail.com>
Subject: Re: [clockevents] WARNING: CPU: 0 PID: 0 at kernel/time/tick-oneshot.c:32
 tick_stop_event()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Jet Chen <jet.chen@intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 June 2014 13:50, Jet Chen <jet.chen@intel.com> wrote:
> Hi Viresh,
>
> 0day kernel testing robot got the below dmesg and the first bad commit is
>
> git://git.linaro.org/people/vireshk/linux tick/ONESHOT-STOPPED

Hi Jet/Fengguang,

Why did your scripts Cc'd LKML for this report? It never used to
happen for my trees Atleast.

These patches haven't been posted to LKML yet and sending
reports there for these wouldn't be good for their fate :)

Anyway, will look at what broke. Thanks.

--
viresh

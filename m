Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726Ab3JYMoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 08:44:55 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54119 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab3JYMoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 08:44:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 Resend 00/34] CPUFreq Cleanup Part III
Date: Fri, 25 Oct 2013 14:56:53 +0200
Message-ID: <14730355.7hm7UiW5IU@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <cover.1382104514.git.viresh.kumar@linaro.org>
References: <cover.1382104514.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, October 18, 2013 07:29:23 PM Viresh Kumar wrote:
> As Part II is already in your linux-next branch, I am sending Part III for
> inclusion in bleeding-edge.
> 
> This is oriented around a light weight ->target_index() routine. CPUFreq
> notifications would be moved to CPUFreq core in the next patchset that I will
> send, as you suggested not to merge multiple series together.. Although both of
> them are oriented towards a light weight ->target_index() routine.
> 
> This is rebased over your bleeding-edge branch + "cpufreq: create per policy
> rwsem instead of per CPU cpu_policy_rwsem"..

Having considered that a bit I think that I'd prefer one patch doing all of
these changes in one go (and with all applicable ACKs collected), one of the
reasons being that if it is necessary to revert that stuff, whatever the
reason, it will be much easier to do that with just one commit than with
34 of them.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

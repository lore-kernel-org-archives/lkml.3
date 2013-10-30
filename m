Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753596Ab3J3Vlq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 17:41:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:57408 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752106Ab3J3Vlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 17:41:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: linaro-kernel@lists.linaro.org, patches@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 Resend 0/2] CPUFreq Cleanup Part IV
Date: Wed, 30 Oct 2013 22:53:51 +0100
Message-ID: <3389791.QB3z2L4pXG@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <cover.1383052613.git.viresh.kumar@linaro.org>
References: <cover.1383052613.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 29, 2013 06:56:05 PM Viresh Kumar wrote:
> Hi Rafael,
> 
> Thanks for applying all earlier patches for v3.13. There are only few left after
> this patchset, i.e. only set with these changes: "create cpufreq_generic_get()
> routine"..
> 
> This patchset moves cpufreq-notifications to core and make ->target_index()
> routines really light weight and gets rid of a lot of redundant code.
> 
> It is already reviewed/Acked/Tested by few people and so should be stable
> enough.
> 
> See if you can still get these for 3.13..
> 
> Viresh Kumar (2):
>   cpufreq: distinguish drivers that do asynchronous notifications
>   cpufreq: move freq change notifications to cpufreq core

[2/2] doesn't apply for me cleanly on top of the big/little changes.

Care to rebase on top of the new bleeding-edge I've just pushed?

Rafael


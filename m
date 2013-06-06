Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754387Ab3FFJ6A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 05:58:00 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:36817 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846Ab3FFJ56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 05:57:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130606095526.GB21181@pd.tnic>
References: <51AF60D5.3080605@semaphore.gr>
	<20130605161703.GA29958@pd.tnic>
	<51AF6E39.2080307@verisign.com>
	<20130606095526.GB21181@pd.tnic>
Date: Thu, 6 Jun 2013 15:27:57 +0530
Message-ID: <CAKohpo=g4Fn-wsgkmujZso_Du3XZHpwSvrFhcbXm72Ne828suw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] cpufreq: ondemand: Change the calculation of
 target frequency
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Borislav Petkov <bp@suse.de>
Cc: David C Niemi <dniemi@verisign.com>,
        Stratos Karafotis <stratosk@semaphore.gr>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-pm@vger.kernel.org,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 June 2013 15:25, Borislav Petkov <bp@suse.de> wrote:
> The correct "fix" for this whole deal is coupling cpufreq with
> the scheduler, as it has been said so many times before. You need
> "something" which can tell you whether raising the freq. is worth it or
> not (i.e. the process is waiting on IO or is executing instructions).

Linaro has got a blueprint in this direction but doesn't have any
proof of concept or RFC patches to share. But that will happen soon.

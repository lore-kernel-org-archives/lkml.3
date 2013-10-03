Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757378Ab3JCEiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 00:38:51 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:39664 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab3JCEit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 00:38:49 -0400
MIME-Version: 1.0
In-Reply-To: <5249C4FB.1060705@linaro.org>
References: <cover.1379779777.git.viresh.kumar@linaro.org>
	<7e9565e323c1e065eeb2a2a1075967bd21ee6066.1379779777.git.viresh.kumar@linaro.org>
	<5243641B.6050604@linaro.org>
	<CAKohpo=3qFQ+gD+3u__NtZEL4xu51FBN+og+_UE7aTR26XvRng@mail.gmail.com>
	<5243EE02.9020207@linaro.org>
	<20130928213343.GA19582@linux.vnet.ibm.com>
	<5249C4FB.1060705@linaro.org>
Date: Thu, 3 Oct 2013 10:08:48 +0530
Message-ID: <CAKohpomcnRrkKmBtrVDyCUx0E00roD2R=XMS3WH9QTpOF9AJjQ@mail.gmail.com>
Subject: Re: [PATCH 19/21] cpuidle: create list of registered drivers
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 October 2013 00:07, Daniel Lezcano <daniel.lezcano@linaro.org> wrote:
> Interesting, thanks for the pointer.

So, should I keep this patch with SRCU?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755113AbaLHNbi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 08:31:38 -0500
Received: from mail-oi0-f52.google.com ([209.85.218.52]:63093 "EHLO
	mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbaLHNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 08:31:36 -0500
MIME-Version: 1.0
In-Reply-To: <20141208125033.GB2980@e104805>
References: <1417806260-9264-1-git-send-email-javi.merino@arm.com>
	<1417806260-9264-7-git-send-email-javi.merino@arm.com>
	<CAOh2x==BKyS08th2d4r0Q2UGqhzAwj6sqOgFsH6J0pWup+OU_A@mail.gmail.com>
	<20141208125033.GB2980@e104805>
Date: Mon, 8 Dec 2014 19:01:35 +0530
Message-ID: <CAKohpokM_8Qm5YH0Xb=n95bP94Qreqpcd1fAyCD2W5u9Pd=ndg@mail.gmail.com>
Subject: Re: [RFC PATCH v6 6/9] thermal: cpu_cooling: implement the power
 cooling device API
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Javi Merino <javi.merino@arm.com>
Cc: Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Punit Agrawal <Punit.Agrawal@arm.com>, Mark Brown <broonie@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 December 2014 at 18:20, Javi Merino <javi.merino@arm.com> wrote:
> Sigh.  Care to share them (privately I guess)?

Sure, you will get that in a separate (private) mail..

> Is this loop pointless?  I seem to recall that it was needed but I
> forgot the details.  If you think it is, I can remove it.

Yes it is pointless. The CPUs you are iterating on, share clock lines
and so they will have same set of OPPs. Just do this for the cpu
we are registering the cooling device.

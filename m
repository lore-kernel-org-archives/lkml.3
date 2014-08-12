Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaHLFwb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 01:52:31 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:37324 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbaHLFw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 01:52:29 -0400
MIME-Version: 1.0
In-Reply-To: <2651364.4shODVy8cx@spock>
References: <4708675.eITUXPv8Ih@spock>
	<2651364.4shODVy8cx@spock>
Date: Tue, 12 Aug 2014 11:22:28 +0530
X-Google-Sender-Auth: gEgiFMGw58PN1XTvXxs_H5372R8
Message-ID: <CAOh2x=k2xpfqz+VjYpPbQy6Z5aeo8DxkYmk7JSmrAZxQOJSU9Q@mail.gmail.com>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 2:23 AM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
> Disabling cpufreq code in kernel config works around this issue.

Yeah, because this is happening while the notifiers are being served.
Can you debug it a bit to go to the exact notifier routine where this crashes?

> Is this bug related to sleeping in atomic context, which is caused by improper
> GFP_KERNEL usage instead of GFP_ATOMIC? Should I test tat patch, or there will
> be another fix?

Which patch are you talking about here?

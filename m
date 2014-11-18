Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbaKRTH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 14:07:59 -0500
Received: from natalenko.name ([78.47.77.148]:58427 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754126AbaKRTH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 14:07:56 -0500
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name 70BF0A1D7
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
Date: Tue, 18 Nov 2014 21:07:51 +0200
Message-ID: <9508464.Rg48i9FdUc@spock>
User-Agent: KMail/4.14.2 (Linux/3.17.0-pf2; KDE/4.14.2; x86_64; ; )
In-Reply-To: <1767434.385ncFoNtj@spock>
References: <4708675.eITUXPv8Ih@spock> <CAKohponLC=NqTUG-mENuJ5Tomx6xgCYEBocj2P5RXXZumZaPZQ@mail.gmail.com> <1767434.385ncFoNtj@spock>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hmmm, weird, acpi=off as well as disabling ASPM and NMI watchdog didn't help :
(.

Now trying to update BIOS.

P.S. Still affected while using 3.17.2 kernel.

On Tuesday 11 November 2014 12:41:18 Oleksandr Natalenko wrote:
> It seems that this bug has nothing to do with acpi-cpufreq code but with
> another ACPI area.
> 
> With ACPI enabled kernel may hang in a day or in a week (never survived more
> than approx. 2 weeks). With acpi=off it seems to work OK. For instance, I
> had to boot Ubuntu installer with acpi disabled to finish it successfully.
> 
> Usually, hanging is not accompanied by panic log. Only small vertical red
> lines appear on the screen near letters (tried to use plaintext 80x25
> console without radeon and got the same issue).
> 
> Still observing this for 3.16 kernel.
> 
> On Wednesday 13 August 2014 10:12:06 Viresh Kumar wrote:
> > On 13 August 2014 00:24, Oleksandr Natalenko <oleksandr@natalenko.name>
> 
> wrote:
> > > Updated logs.
> > 
> > Also will it be possible for you to find the last working kernel after
> > which this
> > happened?
-- 
Oleksandr post-factum Natalenko, MSc
pf-kernel community
https://natalenko.name/

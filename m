Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752726AbaHMMph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:45:37 -0400
Received: from natalenko.name ([78.47.77.148]:36749 "EHLO natalenko.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbaHMMpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:45:35 -0400
DMARC-Filter: OpenDMARC Filter v1.2.0 natalenko.name C3BFCAB8E
Authentication-Results: mail.natalenko.name; dmarc=none header.from=natalenko.name
From: Oleksandr Natalenko <oleksandr@natalenko.name>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [BUG] oops in cpufreq driver with AMD Kaveri CPU
Date: Wed, 13 Aug 2014 15:45:33 +0300
Message-ID: <23471357.28K1EPJDR0@spock>
User-Agent: KMail/4.13.3 (Linux/3.15.0-pf5; KDE/4.13.3; x86_64; ; )
In-Reply-To: <22004375.5nGJFy1vsr@spock>
References: <4708675.eITUXPv8Ih@spock> <CAKohpomF9QLLG-6evXWeUvrR9k7Y8ypVNdXyE4cAi=EFOQviHQ@mail.gmail.com> <22004375.5nGJFy1vsr@spock>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also I've found similar oops report with upstreamed fix (commit 
46a310b80bc2c9ccc019649c9da91194cbc10944).

On Wednesday 13 August 2014 08:56:02 Oleksandr Natalenko wrote:
> On Wednesday 13 August 2014 10:02:26 Viresh Kumar wrote:
> > That's why you should have copied the diff here, so that I could have
> > confirmed if what you have done is correct or not.
> 
> You may check my modifications here [1] or attached to this email.
> 
> [1] https://gist.github.com/bdcc7d41883b5e077974
-- 
Oleksandr post-factum Natalenko, MSc
pf-kernel community
https://natalenko.name/

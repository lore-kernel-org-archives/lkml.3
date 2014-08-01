Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbaHAM3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:29:19 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59156 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750876AbaHAM3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:29:18 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [BUG cpufreq] Invalid argument on writing to scaling_governor
Date: Fri, 01 Aug 2014 14:47:53 +0200
Message-ID: <3664850.5ao49mLJsS@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53DB701B.9070900@redhat.com>
References: <20140801104314.GA741@localhost> <53DB701B.9070900@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 01, 2014 06:46:51 AM Prarit Bhargava wrote:
> 
> On 08/01/2014 06:43 AM, Fengguang Wu wrote:
> > Hi Prarit,
> > 
> > I noticed that commit dbcbfe6aa0d61ae5e13cab43b30802482007c199 ("cpufreq: hold
> > policy->rwsem for duration of changing governors") will cause this problem:
> > 
> > root@nhm4 ~# echo performance > /sys/devices/system/cpu/cpu3/cpufreq/scaling_governor
> > -bash: echo: write error: Invalid argument
> > 
> > root@nhm4 ~# cat /sys/devices/system/cpu/cpu3/cpufreq/scaling_available_governors
> > conservative userspace powersave ondemand performance
> > 
> 
> Rafael, this patch needs to be rejected based on my previous comments, most
> notably Saravana was able to reproduce the original problem.  I'm going to wait
> for his reproducer and see what I can do.

I've dropped it already.  At least as far as I can say it shouldn't be there in
my linux-next branch any more.  Can you double check, please?

Rafael


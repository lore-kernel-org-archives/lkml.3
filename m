Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759743Ab3DBA4V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 20:56:21 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59867 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758369Ab3DBA4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 20:56:20 -0400
Date: Mon, 1 Apr 2013 19:56:18 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nathan Zimmer <nzimmer@sgi.com>, viresh.kumar@linaro.org,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] cpufreq: covert the cpufreq_data_lock to a
	spinlock
Message-ID: <20130402005618.GA12199@gulag1.americas.sgi.com>
References: <5159C147.70800@sgi.com> <1364847069-2887-1-git-send-email-nzimmer@sgi.com> <1364847069-2887-3-git-send-email-nzimmer@sgi.com> <1479737.lmOfIzUVqh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1479737.lmOfIzUVqh@vostro.rjw.lan>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 01, 2013 at 10:41:27PM +0200, Rafael J. Wysocki wrote:
> On Monday, April 01, 2013 03:11:09 PM Nathan Zimmer wrote:
> > This eliminates the rest of the contention found in __cpufreq_cpu_get.
> > I am not seeing a way to use the rcu so we will have to make due with a
> > rwlock for now.
> > 
> > Cc: Viresh Kumar <viresh.kumar@linaro.org>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
> 
> I've already applied this one.
> 
> Can you please check if the version in my tree is OK?
> 
> Rafael
> 

Nope, the previous version was too different, probably best to just replace it.
> 

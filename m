Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935232Ab3DJCMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 22:12:41 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39414 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765597Ab3DJCMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 22:12:39 -0400
Date: Wed, 10 Apr 2013 11:12:36 +0900
From: Simon Horman <horms@verge.net.au>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, robin.randhawa@arm.com, Steve.Bannister@arm.com,
        Liviu.Dudau@arm.com, charles.garcia-tobin@arm.com,
        arvind.chauhan@arm.com, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, patches@linaro.org,
        Paul Mundt <lethal@linux-sh.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH 14/18] cpufreq: sh: move cpufreq driver to drivers/cpufreq
Message-ID: <20130410021236.GK11105@verge.net.au>
References: <cover.1365079581.git.viresh.kumar@linaro.org>
 <3167220d1e262ff22078993a5beec55e82dfd951.1365079581.git.viresh.kumar@linaro.org>
 <20130409125509.GH15412@verge.net.au>
 <CAKohpomqfVqiw1PJxBRRA8=A6hV_63AW4nRpM8TfZPA5bypcKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpomqfVqiw1PJxBRRA8=A6hV_63AW4nRpM8TfZPA5bypcKQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 07:42:51PM +0530, Viresh Kumar wrote:
> On 9 April 2013 18:25, Simon Horman <horms@verge.net.au> wrote:
> > On Thu, Apr 04, 2013 at 06:24:22PM +0530, Viresh Kumar wrote:
> >> This patch moves cpufreq driver of SUPERH architecture to drivers/cpufreq.
> >
> > Why?
> >
> > I am missing the cover email where I assume the explanation lies.
> 
> Hi Simon,
> 
> The idea was to keep all cpufreq drivers at a common and most suitable
> place, so that future consolidation work can be done easily and efficiently.
> 
> So, functionally this patch shouldn't change anything.

Thanks, I understand.

I have no objections to this, but Paul should probably review it.

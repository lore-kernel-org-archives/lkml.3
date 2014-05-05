Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbaEEJhv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 05:37:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:54418 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaEEJht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 05:37:49 -0400
Date: Mon, 5 May 2014 11:37:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, rafael.j.wysocki@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        rajeev.d.muralidhar@intel.com, vishwesh.m.rudramuni@intel.com,
        nicole.chalhoub@intel.com, ajaya.durg@intel.com,
        harinarayanan.seshadri@intel.com
Subject: Re: [RFC PATCH 00/12 v1] A new CPU load metric for power-efficient
 scheduler: CPU ConCurrency
Message-ID: <20140505093744.GO17778@laptop.programming.kicks-ass.net>
References: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399248172-13871-1-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 08:02:40AM +0800, Yuyang Du wrote:
> Hi Ingo, PeterZ, Rafael, and others,

The general code structure is an immediate no go. We're not going to
bolt on anything like this.

I've yet to look at the content.

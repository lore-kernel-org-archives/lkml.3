Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaDYGXp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 02:23:45 -0400
Received: from mail-ee0-f41.google.com ([74.125.83.41]:53741 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168AbaDYGXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 02:23:44 -0400
Message-ID: <1398407020.7893.34.camel@marge.simpson.net>
Subject: Re: [RFC] A new CPU load metric for power-efficient scheduler: CPU
 ConCurrency
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, arjan.van.de.ven@intel.com,
        len.brown@intel.com, rafael.j.wysocki@intel.com, alan.cox@intel.com,
        mark.gross@intel.com, morten.rasmussen@arm.com,
        vincent.guittot@linaro.org
Date: Fri, 25 Apr 2014 08:23:40 +0200
In-Reply-To: <20140424193004.GA2467@intel.com>
References: <20140424193004.GA2467@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-04-25 at 03:30 +0800, Yuyang Du wrote:

> To track CC, we intercept the scheduler in 1) enqueue, 2) dequeue, 3)
> scheduler tick, and 4) enter/exit idle.

Boo hiss to 1, 2 and 4.  Less fastpath math would be better.

-Mike


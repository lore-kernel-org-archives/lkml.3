Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751344AbaC1Guf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 02:50:35 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:56274 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaC1Gud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 02:50:33 -0400
Message-ID: <1395989431.4877.19.camel@marge.simpson.net>
Subject: Re: [RFC II] Splitting scheduler into two halves
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "morten.rasmussen@arm.com" <morten.rasmussen@arm.com>,
        "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
        "Brown, Len" <len.brown@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "Cox, Alan" <alan.cox@intel.com>
Date: Fri, 28 Mar 2014 07:50:31 +0100
In-Reply-To: <20140327221320.GA26843@intel.com>
References: <20140326183721.GC24116@intel.com>
	 <1395896233.5512.45.camel@marge.simpson.net>
	 <20140327072511.GA2555@gmail.com> <20140327221320.GA26843@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-28 at 06:13 +0800, Yuyang Du wrote:

> Spitting does feel brutal...

FWIW, "split" stuck hard in my gullet because task placement is core
fastpath mission.  If the fastpath could afford to and did task
placement perfectly, task placement EDC (if you will) mechanisms would
not exist.

-Mike


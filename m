Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967500Ab3E3Dmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 23:42:43 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:52606 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396Ab3E3Dmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 23:42:36 -0400
Date: Thu, 30 May 2013 11:42:28 +0800
From: Runzhen Wang <runzhen@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Runzhen Wang <icycoder@gmail.com>, linux-kernel@vger.kernel.org,
        acme@redhat.com, mingo@kernel.org, dsahern@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com
Subject: Re: [PATCH] perf tools: fix an error introduced by commit 93cbb398
Message-ID: <20130530034228.GA4592@rz>
Reply-To: Runzhen Wang <runzhen@linux.vnet.ibm.com>
References: <1369668455-6246-1-git-send-email-icycoder@gmail.com>
 <20130529115615.GA1232@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130529115615.GA1232@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13053003-5564-0000-0000-00000821D581
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 29, 2013 at 01:56:15PM +0200, Jiri Olsa wrote:
>On Mon, May 27, 2013 at 11:27:35PM +0800, Runzhen Wang wrote:
>> commit 0a720538e5dd3f424bfcc15c1e4af09df0becf92
>> and
>> commit 93cbb3985d5de867fb32e6e130fcfb1b5de4142b
>> move some contents of Makefile from perf/Makefile to
>> perf/config/Makefile.
>
>hi,
>so you based on latest acme's perf/core, right?
>
>I think it's fixed right now within the branch.
>The issue was there and got fixed by using:
>
>-BASIC_CFLAGS = \
>+BASIC_CFLAGS += \
>
Yes, I based on the perf/core tree.
I have fetched the latest code and found it had been fixed.

thank you :)
Runzhen Wang
>should work right now,
>
>thanks,
>jirka
>


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138AbaGNQOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:14:15 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:31193 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755593AbaGNQOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:14:04 -0400
Date: Mon, 14 Jul 2014 12:14:00 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [for-next][PATCH 04/21] ftrace: Optimize function graph to be
 called directly
Message-ID: <20140714121400.37e9619c@gandalf.local.home>
In-Reply-To: <53C3DF40.8050100@nvidia.com>
References: <20140703160503.006976702@goodmis.org>
	<20140703161224.062459692@goodmis.org>
	<53BED155.9040607@nvidia.com>
	<20140711233610.551c274d@gandalf.local.home>
	<20140711233745.38d8e351@gandalf.local.home>
	<53C3DF40.8050100@nvidia.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014 16:46:40 +0300
Tuomas Tynkkynen <ttynkkynen@nvidia.com> wrote:

 
> Thanks, both of these patches work for me.
> 
> Tested-by: Tuomas Tynkkynen <ttynkkynen@nvidia.com>

Thanks for testing.

I'll pull the first one if for my for-next, and the second one I'll
send to the arm folks for 3.18, after the first one is in mainline.

Hopefully I remember to do that :-)

-- Steve

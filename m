Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3IZC1q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:27:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25720 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab3IZC1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:27:45 -0400
Date: Wed, 25 Sep 2013 22:27:35 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: ftrace eperm BUG.
Message-ID: <20130926022735.GA4653@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20130926014112.GA1991@redhat.com>
 <20130925221025.3aa1db07@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130925221025.3aa1db07@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 10:10:25PM -0400, Steven Rostedt wrote:
 > Hi Dave,
 > 
 > Can you give me any more information on this? Like what you did to
 > trigger it. Was it just loading the fuse module? Or was there more
 > involved.
 
the 'total lockup' part meant the log file never made it to disk, so not really :-/

Usual trinity run. No special params (though I told it to exclude perf_event_open
because of all the other bugs I keep hitting).

 > Also, what kernel and what config?

v3.12-rc2-83-g4b97280
http://codemonkey.org.uk/junk/config

	Dave 
 


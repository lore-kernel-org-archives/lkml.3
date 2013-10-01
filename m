Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab3JAM3F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 08:29:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:14022 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751816Ab3JAM3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 08:29:04 -0400
Message-ID: <1380630531.16752.9.camel@pippen.local.home>
Subject: Re: FTRACE_WARN_ON((rec->flags & ~FTRACE_FL_MASK) == 0))
From: Steven Rostedt <rostedt@goodmis.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Tue, 01 Oct 2013 08:28:51 -0400
In-Reply-To: <20131001042025.GA7038@redhat.com>
References: <20130828034627.GA30596@redhat.com>
	 <20130828095408.37c3dd83@gandalf.local.home>
	 <20130828095833.103ccdf0@gandalf.local.home>
	 <20130828111746.35369b84@gandalf.local.home>
	 <20130828182710.GA14103@redhat.com> <20130828182902.GB14103@redhat.com>
	 <20130828152745.18a73c4e@gandalf.local.home>
	 <20130930171201.GA10474@redhat.com>
	 <1380599766.16752.6.camel@pippen.local.home>
	 <20131001042025.GA7038@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-4+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-01 at 00:20 -0400, Dave Jones wrote:

> It seems like trace-cmd needs to be run as root. all hell will break loose if trinity gets root privs.

Then run this:

trace-cmd record -e syscalls -B trinity su davej -c 'trinity <args>'

-- Steve



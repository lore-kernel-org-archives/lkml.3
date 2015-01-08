Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756930AbbAHRUY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:20:24 -0500
Received: from smtprelay0133.hostedemail.com ([216.40.44.133]:60705 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756863AbbAHRUU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:20:20 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::,RULES_HIT:41:355:379:541:973:988:989:1260:1277:1311:1313:1314:1345:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2893:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:5007:6119:6261:7875:7903:10004:10400:10848:11232:11658:11914:12296:12517:12519:13069:13070:13071:13161:13229:13311:13357:14347:21060:21067:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: gate05_59ca99104f43d
X-Filterd-Recvd-Size: 1290
Date: Thu, 8 Jan 2015 12:20:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: LKML <linux-kernel@vger.kernel.org>, vvs@sw.ru
Subject: Bug with jprobes and function graph tracer
Message-ID: <20150108122016.0241f713@gandalf.local.home>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

First, I would like to wish you a Happy New Year :-)

OK, now back to business.


It has come to my attention that jprobes and function graph tracing do
not play nicely together. I think you once told me they have issues as
well.

A simple way to test this is to load the jprobe_example.ko module and
then run function graph tracing.

Should we try to fix this? Or should it just be that users need to know
not to enable the two together. Or we can prevent one from starting if
the other is being used.

Looking forward to hearing your thoughts on the subject.

-- Steve

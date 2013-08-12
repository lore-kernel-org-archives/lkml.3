Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab3HLBjL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 21:39:11 -0400
Received: from mail-ve0-f169.google.com ([209.85.128.169]:40018 "EHLO
	mail-ve0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285Ab3HLBjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 21:39:07 -0400
Message-ID: <52083CB4.2030308@opersys.com>
Date: Sun, 11 Aug 2013 22:39:00 -0300
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com> <87haevog75.fsf@tassilo.jf.intel.com>
In-Reply-To: <87haevog75.fsf@tassilo.jf.intel.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13-08-11 10:23 PM, Andi Kleen wrote:
> KVM does it, see arch/x86/kvm/pmu.c. Essentially it would be doing RDPMC.

Thx for the pointer, appreciated.

> But the overhead will be likely very high, some sampling approach
> is likely better.

Indeed. It doesn't actually have to be at every single ftrace
begin/exit. But possibly starting with some kind of every nth and then
drilling down as the culprit is incrementally singled-out.

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour


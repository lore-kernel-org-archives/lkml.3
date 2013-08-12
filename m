Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400Ab3HLCAL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 22:00:11 -0400
Received: from mail-ve0-f172.google.com ([209.85.128.172]:41367 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755312Ab3HLCAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 22:00:07 -0400
Message-ID: <5208419E.2000605@opersys.com>
Date: Sun, 11 Aug 2013 22:59:58 -0300
From: Karim Yaghmour <karim.yaghmour@opersys.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804 Thunderbird/17.0.8
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        mingo@elte.hu
Subject: Re: Reading perf counters at ftrace trace boundaries
References: <5208263D.2080205@opersys.com> <87haevog75.fsf@tassilo.jf.intel.com> <52083CB4.2030308@opersys.com> <20130812014748.GP19750@two.firstfloor.org>
In-Reply-To: <20130812014748.GP19750@two.firstfloor.org>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 13-08-11 10:47 PM, Andi Kleen wrote:
> That's what normal sampling already does.
> 
> If you're worried about systematic shadow effects just randomize a bit.

That's actually the point. I'd like to be able to study/compare both
approaches. I could be completely off, but I'd like to see if a divide
and conquer approach (i.e. based on ftrace) wouldn't take the guesswork
out of smart randomization. Just a hunch.

-- 
Karim Yaghmour
CEO - Opersys inc. / www.opersys.com
http://twitter.com/karimyaghmour


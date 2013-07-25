Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab3GYMjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:39:45 -0400
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36222 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab3GYMjj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:39:39 -0400
Message-ID: <51F11C87.5020807@gmail.com>
Date: Thu, 25 Jul 2013 06:39:35 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vince Weaver <vince@deater.net>
CC: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, adrian.hunter@intel.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf: Update perf_event_type documentation
References: <20130716150907.GL23818@dyad.programming.kicks-ass.net> <tip-a5cdd40c9877e9aba704c020fd65d26b5cfecf18@git.kernel.org> <alpine.DEB.2.02.1307241348250.7828@pianoman.cluster.toy> <20130725100451.GJ27075@twins.programming.kicks-ass.net> <alpine.DEB.2.02.1307250828510.18434@pianoman.cluster.toy>
In-Reply-To: <alpine.DEB.2.02.1307250828510.18434@pianoman.cluster.toy>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/13 6:31 AM, Vince Weaver wrote:
> On Thu, 25 Jul 2013, Peter Zijlstra wrote:
>
>> I didn't add any fields, this is simply catching up with what was
>> already there. But yes, this is very much intended to be compatible.
>
> So those id fields have been there since 2.6.31 and just no one noticed
> the header file comments were wrong?  That's fine then, I just have a lot
> of code and other documentation that needs to be updated then.

I believe those fields came in with the sample_id_all patch - 
c980d1091810df13f21aabbce545fd98f545bbf7 - which is 2.6.37.

David

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751055AbaHIEYc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 00:24:32 -0400
Received: from casper.infradead.org ([85.118.1.10]:54247 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798AbaHIEYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 00:24:30 -0400
Message-ID: <53E5A27A.90409@infradead.org>
Date: Fri, 08 Aug 2014 21:24:26 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: =?UTF-8?B?56mN5Li55bC8IERhbiBKYWNvYnNvbg==?= <jidanni@jidanni.org>,
        linux-kernel@vger.kernel.org
Subject: Re: disable "Call Trace:"
References: <877g2jznnt.fsf@jidanni.org>
In-Reply-To: <877g2jznnt.fsf@jidanni.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/14 20:05, 積丹尼 Dan Jacobson wrote:
> Idea: if the user could disable
> the "Call Trace:"
> seen upon "Kernel panic - not syncing: attempted to kill init!"
> he would then be able to see more lines above without having it shoved
> off the screen with the useless (to him) call trace.

When would you want to disable it?  at kernel boot time (as a boot option)
or sometime later?

> e.g., using panic=222 call_trace=disabled would give him enough time and room
> to read more of what happened from the screen.
> --

Makes some sense to me and it's not difficult to implement.

But would you only want to disable Call Trace: on panics or any time that a
call trace might be printed?  and would disabling call trace also disable
the raw stack dump and Code: output, or literally just the call trace?


-- 
~Randy

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaKGUgK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 15:36:10 -0500
Received: from pb-smtp1.int.icgroup.com ([208.72.237.35]:50849 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751480AbaKGUgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 15:36:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=from:to:cc
	:subject:references:date:in-reply-to:message-id:mime-version
	:content-type; q=dns; s=sasl; b=AFp/XRBECPXqKSiCEOeZAmS1D6ktoeIF
	pNDjxkaIxUfE6d/2WbySaJgzzGsaA0onHnidiTj/spicQ6DQR2VJG3x52CW5BnBY
	PA4Gpn6RxAg48uSErrnQ9yuun+7ymr4ZBHf6Sdozw3wiaVcq0S4S+50qYIc3I7jz
	9JsTGtnTGXQ=
From: Junio C Hamano <gitster@pobox.com>
To: Petr Mladek <pmladek@suse.cz>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC][PATCH 10/12 v3] seq-buf: Make seq_buf_bprintf() conditional on CONFIG_BINARY_PRINTF
References: <20141104155237.228431433@goodmis.org>
	<20141104160222.969013383@goodmis.org>
	<20141105170605.GL4570@pathway.suse.cz>
	<20141105153355.22167d0a@gandalf.local.home>
	<20141105154203.126119d8@gandalf.local.home>
	<20141106143935.GE2001@dhcp128.suse.cz>
Date: Fri, 07 Nov 2014 12:36:05 -0800
In-Reply-To: <20141106143935.GE2001@dhcp128.suse.cz> (Petr Mladek's message of
	"Thu, 6 Nov 2014 15:39:38 +0100")
Message-ID: <xmqqr3xeeoju.fsf@gitster.dls.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Pobox-Relay-ID: B33F06F2-66BD-11E4-940F-42529F42C9D4-77302942!pb-smtp1.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Mladek <pmladek@suse.cz> writes:

> On Wed 2014-11-05 15:42:03, Steven Rostedt wrote:
> ...
>> 
>> OK, 'git rebase' is SUPER AWESOME!!!
>> 
>> I just did a git rebase, moved this change to before the file move, and
>> git somehow knew that the change was for the old file, and updated it
>> without any modification from me. The rebase simply succeeded!
>> 
>> I checked, the change still changed seq_buf.c, but in the
>> old kernel/trace directory.
>
> That is really awesome! Dreams become reality.

It is rare to hear somebody talks about Git without having "sucks"
in the same sentence ;-)

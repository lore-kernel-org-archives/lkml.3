Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567AbaEUCei (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 22:34:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58375 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750737AbaEUCeg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 22:34:36 -0400
Message-ID: <537C1083.6030304@zytor.com>
Date: Tue, 20 May 2014 19:33:39 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC] x86_64: A real proposal for iret-less return to kernel
References: <CALCETrXudJ8BkNF_M-r4O40XLN+PnZ5TOZw0P7N4kqo3qngzyg@mail.gmail.com> <1400639227.9759.21.camel@pippen.local.home>
In-Reply-To: <1400639227.9759.21.camel@pippen.local.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2014 07:27 PM, Steven Rostedt wrote:
>>
>> FWIW, if there's a way to read the NMI masking bit, this would be a
>> lot simpler.  I don't know of any way to do that, though.
> 
> Is there such a thing on all x86?
> 

It is not possible to read this bit without the assistance of SMM to the
best of my knowledge.

I'm going to do a detailed review of this proposal as soon as possible,
hopefully later tonight.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756538Ab3JPPXV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 11:23:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59164 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750811Ab3JPPXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 11:23:20 -0400
Message-ID: <525EAF24.9090000@zytor.com>
Date: Wed, 16 Oct 2013 08:22:12 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>, Michael Davidson <md@google.com>,
        Cong Ding <dinggnu@gmail.com>
Subject: Re: [PATCH] x86, relocs: add percpu fixup for GNU ld 2.23
References: <20131016064314.GA2739@www.outflux.net>	<525E3786.7030102@zytor.com> <CAGXu5j+EUA_5E=-r+hhGYarMvt2PWp8Eu==6EP9ZKp9c5VjtYg@mail.gmail.com>
In-Reply-To: <CAGXu5j+EUA_5E=-r+hhGYarMvt2PWp8Eu==6EP9ZKp9c5VjtYg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2013 07:55 AM, Kees Cook wrote:
>>
>> Why isn't this list using a regex like other symbol classes?
> 
> I assume because it was initially a single item and it has grown
> slowly. Would you like me to convert it to a regex instead?
> 

Yes, please.

	-hpa



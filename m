Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758507Ab3GaAC1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 20:02:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:38204 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab3GaAC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 20:02:26 -0400
Message-ID: <51F853E1.2080808@zytor.com>
Date: Tue, 30 Jul 2013 17:01:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: Dave Jones <davej@redhat.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Ksummit-2013-discuss] [ARM ATTEND] catching up on exploit mitigations
References: <CAGXu5jKv9Vt+Hu0mFYaxggLLDZ46U3KR9MKegUoHH8StXCkBtQ@mail.gmail.com> <20130730221435.GA22240@redhat.com> <20130730231120.GC30725@blackmetal.musicnaut.iki.fi> <20130730231533.GA26824@redhat.com> <CAGXu5jLQxE14Gy3x20XMyFyUQKwMQ+RU9S24H742cQevEF9Aew@mail.gmail.com>
In-Reply-To: <CAGXu5jLQxE14Gy3x20XMyFyUQKwMQ+RU9S24H742cQevEF9Aew@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2013 04:33 PM, Kees Cook wrote:
>>
>> If you're running it as a regular user and you can brick the board,
>> you might have bigger problems.
> 
> Exactly, and finding those problems tends to be worth the hardware hassle. :)
> 

Even as root the number of things allowed to brick the hardware is quite
small.  Call it destructive testing.

	-hpa



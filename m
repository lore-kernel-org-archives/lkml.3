Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab3EARfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 13:35:37 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46172 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748Ab3EARfb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 13:35:31 -0400
Message-ID: <51815252.4010103@zytor.com>
Date: Wed, 01 May 2013 10:35:14 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "Theodore Ts'o" <tytso@mit.edu>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Andrew Lutomirski <luto@mit.edu>
Subject: Re: [PATCH v5] x86: Enable fast strings on Intel if BIOS hasn't already
References: <3cdeaedaa41e258e8aa9ca83d79a936e0b9462bc.1367385613.git.luto@amacapital.net> <20130501113352.GA29571@pd.tnic> <20130501163404.GA6286@thunk.org> <518145F6.3060800@zytor.com> <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
In-Reply-To: <CALCETrX0WEGJ0UZz6PyQ4DrnpGg52S0cArDYLQ9Yjz3uic_N4A@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2013 09:54 AM, Andy Lutomirski wrote:
> 
> (Just my luck.  I'm currently trying to implement WT via PAT by
> stealing a slot from either UC or UC-.)
> 

NAK on that.  Use a slot in the upper half, perhaps (we already
blacklist the CPUs for which the upper half aren't usable.)

What do you want WT for, anyway?

> Is there any code that memcpys across memory types and expects any
> particularly sensible behavior out of it?

Unlikely (see my post.)

	-hpa


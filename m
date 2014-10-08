Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755275AbaJHVXJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 17:23:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43997 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbaJHVXH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 17:23:07 -0400
Message-ID: <5435AABC.2010902@zytor.com>
Date: Wed, 08 Oct 2014 14:21:00 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Chuck Ebbert <cebbert.lkml@gmail.com>
CC: Andy Lutomirski <luto@amacapital.net>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Jiri Kosina <jkosina@suse.cz>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: vdso_standalone_test_x86.c build failure on Linus' tree
References: <CA+5PVA5BeRMd28CUZPj+G2VbcwT0pG7gERk65xdMLXSp_59-RA@mail.gmail.com>	<CALCETrUDkHH-FLwq9ZJ0wFeOkQVWUjTh-cJPL4Jq28sHCqhfFA@mail.gmail.com>	<20141008154659.31f46436@as>	<5435A4A4.1070101@zytor.com> <20141008160956.7584d303@as>
In-Reply-To: <20141008160956.7584d303@as>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2014 02:09 PM, Chuck Ebbert wrote:
>>
>> Breaking cross-compilation is not okay, though, regardless of what
>> Fedora does.  It should be okay to, for example, build an i386 kernel on
>> an ARM box.
>>
> 
> I think they tried that for a while, and ended up chasing compiler
> and makefile bugs all day. And then there's the software that wants
> to run self-tests as part of its build...
> 

That we can't solve, but it is not okay to break the kernel build.

	-hpa


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758002AbaGBUFs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 16:05:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53184 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754391AbaGBUFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 16:05:47 -0400
Message-ID: <53B46608.8030408@zytor.com>
Date: Wed, 02 Jul 2014 13:05:28 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUILD BUG][3.16-rc3] Error: too many copied sections (max =
 13)
References: <20140701000913.5ea51f77@gandalf.local.home> <CALCETrW8MYApbyVZ3zxhX3StqVZVBux1xoF8y+gNBAaUP7y6TQ@mail.gmail.com>
In-Reply-To: <CALCETrW8MYApbyVZ3zxhX3StqVZVBux1xoF8y+gNBAaUP7y6TQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 01:00 PM, Andy Lutomirski wrote:
> 
> I managed to munge the binutils sources enough to build binutils 2.21.
> This seems to be a binutils bug: ld generates an empty .rela.dyn.
> Fortunately, it's not generating a DT_RELA dynamic entry.
> 

Not sure if that is a bug.  Unnecessary, yes, but it ought to be legal.

	-hpa


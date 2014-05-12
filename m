Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaELHvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 03:51:04 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47856 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbaELHvB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 03:51:01 -0400
MIME-Version: 1.0
In-Reply-To: <87tx8v4qin.fsf@tassilo.jf.intel.com>
References: <1399552888-11024-1-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMSv6X0+3-uNeiyEPD3sA5dA6Af_M+BT0aeVpa3qMv1aga0q9g@mail.gmail.com> <87tx8v4qin.fsf@tassilo.jf.intel.com>
From: Armin Rigo <arigo@tunes.org>
Date: Mon, 12 May 2014 09:50:20 +0200
X-Google-Sender-Auth: J6shNTe7JR1hpWn8BwmdHxkpr7s
Message-ID: <CAMSv6X1_BzDE1ytPtdGQKK=OJJVpsPrwp2dgSZxA=A03n4rWJw@mail.gmail.com>
Subject: Re: [PATCHv2 0/2] remap_file_pages() decommission
To: Andi Kleen <andi@firstfloor.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, peterz@infradead.org,
        mingo@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 12 May 2014 05:36, Andi Kleen <andi@firstfloor.org> wrote:
>> Here is a note from the PyPy project (mentioned earlier in this
>> thread, and at https://lwn.net/Articles/587923/ ).
>
> Your use is completely bogus. remap_file_pages() pins everything
> and disables any swapping for the area.

? No.  Trying this example: http://bpaste.net/show/fCUTnR9mDzJ2IEKrQLAR/

...really allocates 4GB of RAM, and on a 4GB machine it causes some
swapping.  It seems to work fine.  I'm not sure to understand you.
I'm also not sure that a property as essential as "disables swapping"
should be omitted from the man page; if so, that would be a real man
page bug.


A bientôt,

Armin.

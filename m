Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459Ab3HTH3U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 03:29:20 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:56656 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab3HTH3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 03:29:19 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFxU_n7yNmPKW=b135tf-rZ=pJzndjK6o+=6eshDCa8xAw@mail.gmail.com>
References: <CA+i8gKKzt3Uf7Bt88=AFyKbdHuqaTqy96nCHTtO=t+4+dhQ0Pw@mail.gmail.com>
	<CA+55aFzH7DH0d+DXgQ6T3Us6job8OvVmCJXMp2z3xit86d0ZrA@mail.gmail.com>
	<CA+55aFxU_n7yNmPKW=b135tf-rZ=pJzndjK6o+=6eshDCa8xAw@mail.gmail.com>
Date: Tue, 20 Aug 2013 09:29:18 +0200
Message-ID: <CA+i8gKJrnFBP5QKji_-YbKFxE0+SGjGr20=duUBBvdxUz9egZA@mail.gmail.com>
Subject: Re: commit 94fc5d9: chromium-sandbox core dumped
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Genoud <richard.genoud@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Tue, Aug 20, 2013 at 1:26 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Aug 19, 2013 at 1:25 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> I suspect that last "return 0" at the end should be "return 1". Does
>> that fix things for you? Untested.
>
> Ok. Confirmed. I reproduced the bug that Richard Genoud fixed, and
> also verified that yes, changing that last "return 0" in
> proc_readdir_de() to "return 1" fixes the bug that Emmanuel reported.
> Although I just did it with a special test-program using different
> getdents buffer sizes, so I didn't verify the particular Chromium
> breakage, but that does look like it's the same issue.

Just to confirm it does fix the chromium issue as well.

Thanks.
-- Emmanuel

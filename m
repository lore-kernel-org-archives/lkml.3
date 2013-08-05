Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab3HESIV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 14:08:21 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:46448 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab3HESIT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 14:08:19 -0400
MIME-Version: 1.0
In-Reply-To: <CAMP44s3UGH8Aq-L3CsJ6BFFjZPBG18Gob6_avHMsz8rnrse51g@mail.gmail.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com>
	<CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com>
	<20130805132948.GA14942@redhat.com>
	<CA+55aFy61PbNZda8f+42T9e7TioWd+W1s70UA6h+xnARjX3usA@mail.gmail.com>
	<CAMP44s3UGH8Aq-L3CsJ6BFFjZPBG18Gob6_avHMsz8rnrse51g@mail.gmail.com>
Date: Mon, 5 Aug 2013 13:08:17 -0500
Message-ID: <CAMP44s2wj645tssgffN5QfBB3YPyAWUQ2tBiX=LWLYwX=Nb_QA@mail.gmail.com>
Subject: Re: Linux 3.11-rc4
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 5, 2013 at 12:43 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Aug 5, 2013 at 12:39 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>
>> That said, Felipe, can you double-check that it's not timing-related
>> in some subtle way, and test multiple times with just that commit
>> reverted (and not reverted) to make sure that it's 100% that one
>> single line by that particular commit? Because it does seem very
>> benign..
>
> I tested perhaps dozens of times with the patch, and every one of them
> failed. I tested at least 6 times with the patch reverted, every one
> of them worked.
>
> I'm fairly certain that it's 100% reproducible, so it doesn't seem to be a race.
>
> But I'll double-check.

Yeah, I just tested 5 times; with the patch all 5 times failed,
without the patch all 5 times worked.

-- 
Felipe Contreras

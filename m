Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab3HGTdK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 15:33:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757246Ab3HGTdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 15:33:09 -0400
Date: Wed, 7 Aug 2013 21:27:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Denys Vlasenko <dvlasenk@redhat.com>
Subject: Re: [PATCH 0/1] (Was: Linux 3.11-rc4)
Message-ID: <20130807192734.GA8395@redhat.com>
References: <CA+55aFwTX47vLvZckozZub0rUEo-aCBe7weqe=4mfQGfrW7NUA@mail.gmail.com> <CAMP44s2bOniz4qx5y9h4ppHRUjiPVGL+igSwO5NUJd4zpObxFw@mail.gmail.com> <20130806154314.GA398@redhat.com> <CANOLnOMPhOH5uUBqWwV-YNSeA_YHxL_dDa0ftL4jcWRgGwkfiQ@mail.gmail.com> <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxt1iqJXW=bsETugWVxj9LwZXkq0FT836YMJVsRP9juEQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07, Linus Torvalds wrote:
>
> It's a security issue: setting debug traps on kernel code/data
> addresses can not only leak information, it can cause serious trouble
> (taking a debug trap on the first instruction of an NMI handler etc)
> including kernel stack corruption...

I guess Grazvydas only meant the "unnecessary" align/len/type checks.

But you are right of course.

Oleg.


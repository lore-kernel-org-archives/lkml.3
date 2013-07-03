Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3GCHYQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 03:24:16 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:58783 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754240Ab3GCHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 03:24:14 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130702223714.GA28048@redhat.com>
References: <CA+icZUXo=Z4gDfCMvLqRQDq_fpNAq+UqtUw=jrU=3=kVZP-2+A@mail.gmail.com>
	<20130630181945.GA5171@redhat.com>
	<CA+icZUWLUSg-Sfd9FHXs8Amz+-s6vs_VOJsQpUSa9+fYM8XyNQ@mail.gmail.com>
	<20130702223714.GA28048@redhat.com>
Date: Wed, 3 Jul 2013 09:24:12 +0200
Message-ID: <CA+icZUWV+O9x7VUt9ocu3kk10vqDv3oEQ533mnsWhBiEKk7fJQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Jun 28 [ BISECTED: rsyslog/imklog: High CPU
 usage ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>, Lukas Czerner <lczerner@redhat.com>,
        Samuel Ortiz <samuel@sortiz.org>, Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>, Julian Anastasov <ja@ssi.bg>,
        Ralf Baechle <ralf@linux-mips.org>, Valdis.Kletnieks@vt.edu,
        linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 3, 2013 at 12:37 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> Hi Sedat,
>
> On 07/02, Sedat Dilek wrote:
>>
>> did you made a cleaned-up version?
>> AFAICS v3, I read that on linux-mm ML, sorry if I ask here in this thread.
>
> Yes, I am going to send v3 with this fix + another minor change.
> Sorry for delay, I was distracted, will try tomorrow.
>
> Besides, I think Andrew and Stephen need a rest before I try to
> break wait.h or the third time.
>

Everyone should get a 3rd chance :-).

BTW, dealing with such issues makes me more and more familiar with my
Linux-systems.

- Sedat -

> Oleg.
>

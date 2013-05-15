Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab3EOFbM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 01:31:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab3EOFbK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 01:31:10 -0400
Date: Wed, 15 May 2013 11:00:32 +0530
From: Amit Shah <amit.shah@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "kvmarm@lists.cs.columbia.edu" <kvmarm@lists.cs.columbia.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Patch Tracking <patches@linaro.org>,
        Anup Patel <anup.patel@linaro.org>
Subject: Re: [PATCH V2 2/3] Documentation: virtio: Add emergency write
 (emerg_wr) config register in virtio console.
Message-ID: <20130515053032.GA32133@amit.redhat.com>
References: <1367842791-30285-1-git-send-email-pranavkumar@linaro.org>
 <1367842791-30285-3-git-send-email-pranavkumar@linaro.org>
 <8761yn382w.fsf@rustcorp.com.au>
 <CAAHg+Hi6BHqwOznnC9qxkc5pBWz7r5qpz9Nhh=EeNenhjhHohg@mail.gmail.com>
 <87hai427di.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87hai427di.fsf@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (Wed) 15 May 2013 [13:59:29], Rusty Russell wrote:
> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> > Hi Rusty,
> >
> > On 13 May 2013 08:22, Rusty Russell <rusty@rustcorp.com.au> wrote:
> >> Pranavkumar Sawargaonkar <pranavkumar@linaro.org> writes:
> >>> Signed-off-by: Pranavkumar Sawargaonkar <pranavkumar@linaro.org>
> >>> Signed-off-by: Anup Patel <anup.patel@linaro.org>
> >>> ---
> >>>  Documentation/virtual/virtio-spec.txt |    8 +++++++-
> >>>  1 file changed, 7 insertions(+), 1 deletion(-)
> >>
> >> OK, I applied this to the lyx master, with three changes:
> >> 1) Changed "filed" to "field".
> >> 2) Added ", or even acknowledging the feature" after "without
> >>    initializing virtio queues".
> >> 3) Added an initial point to the Device Initialization section:
> >>
> >>    1. If the VIRTIO_CONSOLE_F_EMERG_WRITE feature is offered, the
> >>    emerg_wr field of the configuration can be written at any time. Thus
> >>    it should work for very early boot debugging output as well as
> >>    catastophic OS failures (eg. virtio ring corruption).
> >
> > Thanks for applying this patch.
> > Have you also applied first patch ([PATCH V2 1/3] virtio: console: Add
> > emergency writeonly register to config space)
> > with this?  (https://lkml.org/lkml/2013/5/6/169)
> 
> Would like Amit's Ack, since he's de-facto console maintainer.

I've been away, and am reviewing the discussions here.  Expect a
response later today.

Thanks,

		Amit

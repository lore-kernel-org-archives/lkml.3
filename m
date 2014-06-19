Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757328AbaFSF0h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:26:37 -0400
Received: from mail-oa0-f51.google.com ([209.85.219.51]:58997 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768AbaFSF0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:26:35 -0400
MIME-Version: 1.0
In-Reply-To: <20140619045438.GA14497@kroah.com>
References: <20140618102957.15728.43525.stgit@patser> <20140618103653.15728.4942.stgit@patser>
 <20140619011653.GF10921@kroah.com> <CAF6AEGtzv0+PoMwSfK=NTYAO=bxsnS2BcwLxLNmLqnGTEUV8ng@mail.gmail.com>
 <CAO_48GF_hb5PZFwEmx8vsy+gW=Mq=cnEq8H4W74hCdz9qg0+SQ@mail.gmail.com> <20140619045438.GA14497@kroah.com>
From: Sumit Semwal <sumit.semwal@linaro.org>
Date: Thu, 19 Jun 2014 10:56:15 +0530
Message-ID: <CAO_48GE8t0zT2p=JCYvgYPQKhw6QiGEA-ufzKqZUirQLQs+nqw@mail.gmail.com>
Subject: Re: [REPOST PATCH 1/8] fence: dma-buf cross-device synchronization (v17)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Rob Clark <robdclark@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>,
        linux-arch <linux-arch@vger.kernel.org>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Colin Cross <ccross@google.com>, Daniel Vetter <daniel@ffwll.ch>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19 June 2014 10:24, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Thu, Jun 19, 2014 at 09:57:35AM +0530, Sumit Semwal wrote:
>> Hi Greg,
>>

>> >>
>> >> Who is going to sign up to maintain this code?  (hint, it's not me...)
>> >
>> > that would be Sumit (dma-buf tree)..
>> >
>> > probably we should move fence/reservation/dma-buf into drivers/dma-buf
>> > (or something approximately like that)
>> Yes, that would be me - it might be better to create a new directory
>> as suggested above (drivers/dma-buf).
>
> That's fine with me, there is going to be more than just one file in
> there, right?  :)
>
> greg k-h
Certainly atleast 3 :)

~sumit

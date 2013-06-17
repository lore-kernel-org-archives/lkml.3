Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750891Ab3FQEDJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 00:03:09 -0400
Received: from ozlabs.org ([203.10.76.45]:57692 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab3FQEDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 00:03:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Robert Tivy <rtivy@ti.com>
Subject: Re: [PATCH 6/9] remoteproc: don't use PTR_RET().
In-Reply-To: <CAK=WgbbC9=H=VL9ugSAoGZXu0mSRB+NRoVYzkDdKw0M=L4v5aQ@mail.gmail.com>
References: <87ehc2rczo.fsf@rustcorp.com.au> <1371357768-4968-1-git-send-email-rusty@rustcorp.com.au> <1371357768-4968-6-git-send-email-rusty@rustcorp.com.au> <CAK=WgbbC9=H=VL9ugSAoGZXu0mSRB+NRoVYzkDdKw0M=L4v5aQ@mail.gmail.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 17 Jun 2013 13:19:26 +0930
Message-ID: <87ip1dpfax.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ohad Ben-Cohen <ohad@wizery.com> writes:
> On Sun, Jun 16, 2013 at 7:42 AM, Rusty Russell <rusty@rustcorp.com.au> wrote:
>>
>> We've already tested that it's an error.
>>
>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>> Cc: Robert Tivy <rtivy@ti.com>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> Acked-by: Ohad Ben-Cohen <ohad@wizery.com>
>
> Thanks Rusty, feel free to take it via your tree together with the
> rest of the PTR_RET patches.

Thanks, done.

Cheers,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027AbaE0Fwv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 01:52:51 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:62933 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993AbaE0Fws convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 01:52:48 -0400
MIME-Version: 1.0
In-Reply-To: <20140526090623.77186cdf@canb.auug.org.au>
References: <1400965544-20092-1-git-send-email-vincent.stehle@laposte.net>
	<CANq1E4QdGeHeuCu9LvPkbGZX5C+ax4fWVqq4kJ5wMUBx5uWZrQ@mail.gmail.com>
	<20140525225435.GZ3693@n2100.arm.linux.org.uk>
	<20140526090623.77186cdf@canb.auug.org.au>
Date: Tue, 27 May 2014 15:52:46 +1000
Message-ID: <CAPM=9twkXSA2uyVPfdz=qbpM5H96tHHaD8HnTf7YGpB0QX1WZw@mail.gmail.com>
Subject: Re: [PATCH linux-next] DRM: Armada: update dma_buf_export use
From: Dave Airlie <airlied@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Sumit Semwal <sumit.semwal@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        =?UTF-8?Q?Vincent_Stehl=C3=A9?= <vincent.stehle@laposte.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 May 2014 09:06, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi all,
>
> On Sun, 25 May 2014 23:54:35 +0100 Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
>>
>> On Sun, May 25, 2014 at 02:08:48PM +0200, David Herrmann wrote:
>> >
>> > On Sat, May 24, 2014 at 11:05 PM, Vincent Stehlé
>> > <vincent.stehle@laposte.net> wrote:
>> > > The dma_buf_export function was updated in commit 4bcec44ffaf9 'dma-buf: use
>> > > reservation objects' to take a reservation object parameter; update Armada
>> > > export method accordingly.
>> > >
>> > > This fixes the following compilation error:
>> > >
>> > >   drivers/gpu/drm/armada/armada_gem.c: In function ‘armada_gem_prime_export’:
>> > >   drivers/gpu/drm/armada/armada_gem.c:544:16: error: macro "dma_buf_export" requires 5 arguments, but only 4 given
>> > >
>> > > Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
>> > > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
>> > > Cc: David Airlie <airlied@linux.ie>
>> > > Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
>> > > Cc: Sumit Semwal <sumit.semwal@linaro.org>
>> >
>> > Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
>>
>> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>
>>
>> Airlied, can you merge this please?  Thanks.
>
> Except that commit 4bcec44ffaf9 'dma-buf: use reservation objects'
> comes from the dma-buf tree, so Sumit needs to add this commit to his
> tree.
>

Then we should cc him.

Dave.

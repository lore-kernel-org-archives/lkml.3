Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab3JKRzD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 13:55:03 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:60747 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754774Ab3JKRy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 13:54:59 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1310110622460.14758@skynet.skynet.ie>
References: <alpine.DEB.2.00.1310110622460.14758@skynet.skynet.ie>
Date: Fri, 11 Oct 2013 10:54:58 -0700
X-Google-Sender-Auth: 6yHuBahiNB8ArwyR5_ldq16Ywvo
Message-ID: <CA+55aFwAbcQY3RDw0L4RQgX7M98=5ZiWfQc4r-Q+WUhcJ3kSfA@mail.gmail.com>
Subject: Re: [git pull] drm fixes
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 10:28 PM, Dave Airlie <airlied@linux.ie> wrote:
>
> and one pain in the ass revert, so we have VGA arbitration that when
> implemented 4-5 years ago really hoped that GPUs could remove themselves
> from arbitration completely once they had a kernel driver, it seems Intel
> hw designers decided that was too nice a facility to allow us to have so
> they removed it when they went on-die (so since Ironlake at least), now
> Alex Williamson added support for VGA arbitration for newer GPUs however
> this now exposes itself to userspace as requireing arbitration of GPU VGA
> regions and the X server gets involved and disables things that it can't
> handle when VGA access is possibly required around every operation, so in
> order to break userspace we just reverted things back to the old known
> broken status so maybe we can try and design out way out. Ville also had a
> patch to use stop machine for the two times Intel needs to access VGA
> space, that might be acceptable with some rework, but for now myself and
> Daniel agreed to just go back.

Your explanation messages tend to channel James Joyce. They may be
literary works of art, but it _does_ occasionally make them somewhat
hard to read.

I have tried to turn them into slightly less stream-of-consciousness.

             Linus

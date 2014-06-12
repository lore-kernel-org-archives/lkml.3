Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752331AbaFLTNp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 15:13:45 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35207 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaFLTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 15:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwOvYO2pSvd835R=iU3=8i5jYu07FbifU-nOVj5pecBmA@mail.gmail.com>
References: <alpine.DEB.2.00.1406120157510.2473@skynet.skynet.ie>
	<CA+55aFwOvYO2pSvd835R=iU3=8i5jYu07FbifU-nOVj5pecBmA@mail.gmail.com>
Date: Thu, 12 Jun 2014 12:13:41 -0700
X-Google-Sender-Auth: v42Puwo_DtnxuotYClF04pm-hZc
Message-ID: <CA+55aFwiFAFLHBV_=vHm-3-g5pog01A0mhMpo4yCDnaKMdhFnA@mail.gmail.com>
Subject: Re: [git pull] drm merge tree
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 12:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I just had the machine reboot on me when booting this and starting X,
> leaving nothing in the logs.

Ok, I can't recreate it, and as such I can't be sure that it was even
the drm merge that causes it (although the timing was suspicious). So
in it stays, since it's not making my life impossible.

But please keep an eye out for any i915 issues..

           Linus

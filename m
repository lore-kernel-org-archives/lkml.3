Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772AbaLZAS4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2014 19:18:56 -0500
Received: from mail-qg0-f49.google.com ([209.85.192.49]:61700 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163AbaLZASx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2014 19:18:53 -0500
MIME-Version: 1.0
In-Reply-To: <54995B63.5090808@amd.com>
References: <1419246435-7050-1-git-send-email-oded.gabbay@amd.com>
	<1419246435-7050-2-git-send-email-oded.gabbay@amd.com>
	<54995B63.5090808@amd.com>
Date: Thu, 25 Dec 2014 16:18:52 -0800
X-Google-Sender-Auth: Scv7WTOwiOgBLYASEYjI00Lbv4c
Message-ID: <CA+55aFz+XGNc2tU2b8PUg4wFrTv0LuypXrR_CBQNnuy8wTym9A@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: Move iommu/ before gpu/ in Makefile
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: David Airlie <airlied@linux.ie>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Dana Elifaz <Dana.Elifaz@amd.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        iommu@lists.linux-foundation.org,
        =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 4:09 AM, Oded Gabbay <oded.gabbay@amd.com> wrote:
> Hello Linus,
> Dave Airlie asked me to send this patch to you for review.

I'm not entirely happy about the fix, since we generally *should*
order things by the different init-levels, but we've done the link
order thing before, and I guess it's acceptable as a band-aid, even if
it's not really how things are supposed to be done.

                      Linus

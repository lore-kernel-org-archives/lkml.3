Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab3ILWB1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 18:01:27 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:45171 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755701Ab3ILWBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 18:01:24 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzdVf5veU4UMZ8tiThJauatroV5ZvQ0dtg6Y6jZnv5ZDg@mail.gmail.com>
References: <1378997735-22844-1-git-send-email-Waiman.Long@hp.com>
	<CA+55aFwsqHJE1D-z8_kU+1VEpUTB=EU57kqmKao580gYZVOjrw@mail.gmail.com>
	<CA+55aFy8Nq7yf9CJwFuyfSmkUzFKRHHOE6O8=4HjmaWpku3fhw@mail.gmail.com>
	<52320FA3.7000908@hp.com>
	<CA+55aFyvC=vKWn2-PBrfyFB9gS08DBUNwXvHhO6KaoLz=SJbMw@mail.gmail.com>
	<20130912215650.GQ13318@ZenIV.linux.org.uk>
	<CA+55aFzdVf5veU4UMZ8tiThJauatroV5ZvQ0dtg6Y6jZnv5ZDg@mail.gmail.com>
Date: Thu, 12 Sep 2013 15:01:23 -0700
X-Google-Sender-Auth: Q-ZWQuIV4OB3b2hE7ocm4DjU2Lg
Message-ID: <CA+55aFxqb4EbMbOgbGRk1tYfQX=dt7W2mH2ggRgLTntqZ8gx_Q@mail.gmail.com>
Subject: Re: [PATCH 0/2 v2] dcache: get/release read lock in
 read_seqbegin_or_lock() & friend
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Waiman Long <waiman.long@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 3:00 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So if you were planning a "pile 4", I hope we can leave it for 3.13.

.. actually, this would be "pile 4", so it's "pile 5" that I hope not to get..

          Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab3AWAWg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:22:36 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:34337 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3AWAWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:22:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130123001515.GA5359@htj.dyndns.org>
References: <Pine.LNX.4.44L0.1301131153520.17578-100000@netrider.rowland.org>
 <CALxABCYtKJD4YrPxy6p+Frim8erccp3ine7SVEV9ReoaRh1BWQ@mail.gmail.com>
 <CACVXFVPMH-CHGw2EVwgYK5ozn1NAygT0f9=Df4vhSJmYYOZBMw@mail.gmail.com>
 <CACVXFVNvBeHG2TgfNY-wRQYtqsd6v-3AAiQVPAECuRnJ--ON-g@mail.gmail.com>
 <CA+55aFxV40V2WvNtJY3EC0F-B9wPk8CV2o1TTTyoF4CoWH7rhQ@mail.gmail.com>
 <CACVXFVNB3bOxF8aZ3Cg3vtOQZR=jNsDj=RbUQcKAhuc0c--Tyg@mail.gmail.com>
 <CACVXFVMFyhM+EsBytw0MKVW4Vp4aOtc_5sfX0v-643m7fwnc3Q@mail.gmail.com>
 <CA+55aFyOyTS1ZCm6UWqGLteoPuFXKu0WSYB-aTeRYvJUYPqe5A@mail.gmail.com>
 <20130115183204.GE2668@htj.dyndns.org> <20130116171952.GQ2668@htj.dyndns.org> <20130123001515.GA5359@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 Jan 2013 16:22:11 -0800
X-Google-Sender-Auth: bFqyVv-J3kujVNRlGlOtYx8JQ3k
Message-ID: <CA+55aFwxQVf6+dGWvG3bOMaCp8RFFYvu9VP1uP=UXz+XfOriXg@mail.gmail.com>
Subject: Re: [PATCH v2] async: fix __lowest_in_progress()
To: Tejun Heo <tj@kernel.org>
Cc: Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 4:15 PM, Tejun Heo <tj@kernel.org> wrote:
>
> Linus, I've updated the description to better explain why it's broken.
> The code is ugly but cleanup patches are already ready, so it will be
> cleaned up during 3.9-rc1.  How should this be routed?

I'm not a huge fan of the patch and I might even have preferred the
whole cleanup, but I took it as-is.

            Linus

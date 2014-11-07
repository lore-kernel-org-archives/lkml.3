Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaKGStA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 13:49:00 -0500
Received: from tex.lwn.net ([70.33.254.29]:54677 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaKGSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 13:48:58 -0500
Date: Fri, 7 Nov 2014 13:48:54 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Daniel Dressler <danieru.dressler@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Tommi Rantala <tt.rantala@gmail.com>,
        Ted Mielczarek <ted@mielczarek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Frank Razenberg <frank@zzattack.org>,
        Benjamin Valentin <benpicco@zedat.fu-berlin.de>,
        Petr Sebor <petr@scssoft.com>,
        Thomaz de Oliveira dos Reis <thor27@gmail.com>,
        linux-doc@vger.kernel.org (open list:DOCUMENTATION),
        linux-kernel@vger.kernel.org (open list), linux-input@vger.kernel.org
Subject: Re: [PATCH 1/1] Input: xpad - update docs to reflect current state
Message-ID: <20141107134854.56305dbb@lwn.net>
In-Reply-To: <1415004836-22871-1-git-send-email-danieru.dressler@gmail.com>
References: <1415004836-22871-1-git-send-email-danieru.dressler@gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  3 Nov 2014 17:53:06 +0900
Daniel Dressler <danieru.dressler@gmail.com> wrote:

> The last time this documentation was accurate was
> just over 8 years ago. In this time we've added
> support for two new generations of Xbox console
> controllers and dozens of third-party controllers.
> 
> This patch unifies terminology and makes it explicit
> which model of controller a sentence refers to.

So this seems like a useful update, and I was looking at pulling it into
the docs tree.  But this hunk:

> diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
> index 2ed7905..7e2e047 100644
> --- a/drivers/input/joystick/xpad.c
> +++ b/drivers/input/joystick/xpad.c
> @@ -40,8 +40,8 @@
>   *
>   * TODO:
>   *  - fine tune axes (especially trigger axes)
> - *  - fix "analog" buttons (reported as digital now)
> - *  - get rumble working
> + *  - add original xbox rumble pack support
> + *  - add xbox one rumble support
>   *  - need USB IDs for other dance pads
>   *
>   * History:

Seems like a different change that shouldn't be mixed up with the doc
update.  Send me a version without that change and, in the absence
of complaints, I'll apply it.

Thanks,

jon

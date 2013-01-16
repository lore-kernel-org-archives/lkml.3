Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756861Ab3APS5v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 13:57:51 -0500
Received: from mail-vb0-f52.google.com ([209.85.212.52]:51668 "EHLO
	mail-vb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753807Ab3APS5t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 13:57:49 -0500
MIME-Version: 1.0
In-Reply-To: <87obgpcmqs.fsf@tucsk.piliscsaba.szeredi.hu>
References: <87obgpcmqs.fsf@tucsk.piliscsaba.szeredi.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Jan 2013 10:57:27 -0800
X-Google-Sender-Auth: vcdtexQFo4sDVHgcfqbWlq7DrFw
Message-ID: <CA+55aFw4rer-SPq3gv8RHUba2-w2XX-z-rSXM8C2XuqrfSCG9Q@mail.gmail.com>
Subject: Re: [GIT PULL] fuse updates for 3.8
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Maxim Patlasov <mpatlasov@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 4:53 AM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> The large part of this pull request is a patch series from Maxim
> Patlasov to optimize scatter-gather direct IO.  The rest is small fixes
> and cleanups.

Please just send the fixes. We're post-rc3, I'm not willing to take
new code like this. Send the actual new code during the next merge
window.

             Linus

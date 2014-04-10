Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934508AbaDJASQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 20:18:16 -0400
Received: from mail-ve0-f174.google.com ([209.85.128.174]:54607 "EHLO
	mail-ve0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933317AbaDJASO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 20:18:14 -0400
MIME-Version: 1.0
In-Reply-To: <19406418.LIeRWhPu7h@x2>
References: <1396220874.6974.5.camel@localhost>
	<19406418.LIeRWhPu7h@x2>
Date: Wed, 9 Apr 2014 17:18:13 -0700
X-Google-Sender-Auth: 5wb1snVRUhoHRj682JVbSWfnGSc
Message-ID: <CA+55aFwaqL608yTj_t0UoKZyfpuZkYZFwaiAjX5G4SdFm3KJqA@mail.gmail.com>
Subject: Re: [PATCH for v3.14] AUDIT: Allow login in non-init namespaces
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steve Grubb <sgrubb@redhat.com>
Cc: linux-audit@redhat.com, Eric Paris <eparis@redhat.com>, rgb@redhat.com,
        Linux Containers <containers@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 9, 2014 at 5:08 PM, Steve Grubb <sgrubb@redhat.com> wrote:
>
> This is a requirement. I do not advocate "tricking" user space.

It's not about tricking user space. This is how we used to behave.
ECONNREFUSED is what you got in a non-init namespace. So this is a
*regression fix*, not some kind of trick.

And there is absolutely nothing to "discuss" about regression fixes.

If people want to start auditing non-init namespaces, go right ahead.
But it will *not* happen by breaking old behavior that people depended
on.

            Linus

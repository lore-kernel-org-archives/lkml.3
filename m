Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754189AbaBZVLa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 16:11:30 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46862 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754135AbaBZVL0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 16:11:26 -0500
MIME-Version: 1.0
In-Reply-To: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
Date: Wed, 26 Feb 2014 13:11:25 -0800
X-Google-Sender-Auth: gibaTnEdLh4-HVLnLyzTU-pc7lQ
Message-ID: <CAGXu5j+b49grru-=DTRC0wx5LTOHN_jKL0Q++uW0Mzy+BxDf4w@mail.gmail.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
From: Kees Cook <keescook@chromium.org>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Greg KH <gregkh@linuxfoundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        James Morris <jmorris@namei.org>,
        linux-security-module <linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 12:11 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> The conclusion we came to at Plumbers was that this patchset was basically
> fine but that Linus hated the name "securelevel" more than I hate pickled
> herring, so after thinking about this for a few months I've come up with
> "Trusted Kernel". This flag indicates that the kernel is, via some
> external mechanism, trusted and should behave that way. If firmware has
> some way to verify the kernel, it can pass that information on. If userspace
> has some way to verify the kernel, it can set the flag itself. However,
> userspace should not attempt to use the flag as a means to verify that the
> kernel was trusted - untrusted userspace could have set it on an untrusted
> kernel, but by the same metric an untrusted kernel could just set it itself.
>
> If people object to this name then I swear to god that I will open a poll
> on Phoronix to decide the next attempt and you will like that even less.

For the Chrome OS use-case, it might be better described as "untrusted
userspace", but that seems unfriendly. :) The "trusted kernel" name
seems fine to me.

-Kees

-- 
Kees Cook
Chrome OS Security

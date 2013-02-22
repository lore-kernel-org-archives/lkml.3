Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755775Ab3BVBsk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 20:48:40 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:39442 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3BVBsh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 20:48:37 -0500
MIME-Version: 1.0
In-Reply-To: <00b801ce0ff2$c3dfa800$4b9ef800$%han@samsung.com>
References: <00b801ce0ff2$c3dfa800$4b9ef800$%han@samsung.com>
Date: Thu, 21 Feb 2013 17:48:37 -0800
X-Google-Sender-Auth: 5-h1rC_K5d1AqPy_QUI_Bbymivs
Message-ID: <CA+55aFyaQDwQPW3GMZu9gcQr-FhPY3vHKXUo0HMERR0Uxw-xmQ@mail.gmail.com>
Subject: Re: [GIT PULL] samsung-fb updates for v3.9
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-fbdev <linux-fbdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 20, 2013 at 9:17 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> samsung-fb updates for the v3.9:

Ok, there's a good gpg signed tag now, with a very recent gpg key. Try
to get that key signed by a few people.

Anyway, I pulled, and noticed that I had gotten these patches through
Andrew, so then I undid my pull as unnecessary. But I bet Andrew will
be happy if he can rely on you maintaining it, so I guess this whole
thing will work out in the future.

Of course, I'd be even happier if somebody were to step up maintaining
all of fbdev. Oh well.

            Linus

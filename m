Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab3BUP5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 10:57:18 -0500
Received: from mail-vb0-f54.google.com ([209.85.212.54]:53860 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754417Ab3BUP5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 10:57:17 -0500
MIME-Version: 1.0
In-Reply-To: <20130221120025.5605.43099.stgit@warthog.procyon.org.uk>
References: <20130221120025.5605.43099.stgit@warthog.procyon.org.uk>
Date: Thu, 21 Feb 2013 07:57:15 -0800
X-Google-Sender-Auth: K-PMpItKDgtFbdDDK_Wr3kjAwwo
Message-ID: <CA+55aFxPvK1ZVOEEGVX9deUdqqb87FdNYJhNojuzmhg1ry3PjA@mail.gmail.com>
Subject: Re: [PATCH] KEYS: Revert one application of "Fix unreachable code"
 patch [ver #2]
From: Linus Torvalds <torvalds@linux-foundation.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jiri Kosina <jkosina@suse.cz>,
        keyrings@linux-nfs.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 21, 2013 at 4:00 AM, David Howells <dhowells@redhat.com> wrote:
> A patch to fix some unreachable code in search_my_process_keyrings() got
> applied twice by two different routes upstream:

Ok, applied. Let's not apply this one twice. So Andrew, please don't
put it in your queue ;)

              Linus

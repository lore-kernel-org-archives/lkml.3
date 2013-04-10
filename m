Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937625Ab3DJWyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:54:49 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:44479 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937317Ab3DJWyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:54:45 -0400
MIME-Version: 1.0
In-Reply-To: <20130410224342.778004071@linuxfoundation.org>
References: <20130410224333.114387235@linuxfoundation.org>
	<20130410224342.778004071@linuxfoundation.org>
Date: Wed, 10 Apr 2013 15:54:44 -0700
X-Google-Sender-Auth: KZblAK9pdvzChjTiPTYuCX1pRyk
Message-ID: <CA+55aFzVuENsvQM1huNkJRcvcWow1xcVeaGkbYEd-JonJ9HqEw@mail.gmail.com>
Subject: Re: [ 41/64] spinlocks and preemption points need to be at least
 compiler barriers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 3:46 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> Note for stable: use discretion when/if applying this.  As mentioned,
> this bug may never have actually bitten anybody, and gcc may never have
> done the required code motion for it to possibly ever trigger in
> practice.

No objections, I just wanted to make sure the stable people had
noticed this message to them...

             Linus

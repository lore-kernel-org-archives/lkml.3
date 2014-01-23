Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaAWAIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 19:08:55 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46381 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127AbaAWAIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 19:08:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140122233622.GB27916@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
	<CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
	<20140122233622.GB27916@quack.suse.cz>
Date: Wed, 22 Jan 2014 16:08:52 -0800
X-Google-Sender-Auth: MddlFNMDGuLaXkGOBYFp-X1sRFk
Message-ID: <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
Subject: Re: fanotify use after free.
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Jan Kara <jack@suse.cz>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 3:36 PM, Jan Kara <jack@suse.cz> wrote:
>
> But refcounting seems like an overkill for this - there is exactly one
> fanotify_response_event structure iff it is a permission event. So
> something like the (completely untested) attached patch should fix the
> problem. But I agree it's a bit ugly so we might want something different.
> I'll try to think about something better tomorrow.

Ok, In the meantime, Dave, can you verify whether this hacky patch
fixes your problem?

              Linus

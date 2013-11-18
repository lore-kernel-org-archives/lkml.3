Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752477Ab3KRSje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:39:34 -0500
Received: from mail-oa0-f45.google.com ([209.85.219.45]:35242 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab3KRSjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:39:22 -0500
MIME-Version: 1.0
In-Reply-To: <20131116190202.GD22666@redhat.com>
References: <20131101232521.GA23119@www.outflux.net>
	<20131114170337.GA11068@redhat.com>
	<CAGXu5jLXpLqjCAMFwKp7t7GpMq4+WBqNzSFC=up+CBvgGDuFCw@mail.gmail.com>
	<20131115203652.GA13476@redhat.com>
	<CAGXu5j+=LZYAczLVawGPAxd=9VX1FupWZq+2858GsrD1YprL3w@mail.gmail.com>
	<20131116190057.GA22666@redhat.com>
	<20131116190202.GD22666@redhat.com>
Date: Mon, 18 Nov 2013 10:39:21 -0800
X-Google-Sender-Auth: gDTFDVijd-UKPk3CgMRe_RTK7A4
Message-ID: <CAGXu5jLxD6fqMxakwNP+dToFS=aZ-AyLaPZu9LaoSkYofoq10w@mail.gmail.com>
Subject: Re: [PATCH 3/3] make __get_dumpable/get_dumpable inline, kill fs/coredump.h
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "security@kernel.org" <security@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Vasily Kulikov <segoon@openwall.com>,
        Petr Matousek <pmatouse@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org,
        Alex Kelly <alex.page.kelly@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 16, 2013 at 11:02 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> 1. Remove fs/coredump.h. It is not clear why do we need it,
>    it only declares __get_dumpable(), signal.c includes it
>    for no reason.
>
> 2. Now that get_dumpable() and __get_dumpable() are really
>    trivial make them inline in linux/sched.h.
>
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security

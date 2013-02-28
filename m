Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760079Ab3B1SsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 13:48:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752767Ab3B1Sr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 13:47:59 -0500
Date: Thu, 28 Feb 2013 19:46:22 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] coredump: make it freezable (almost)
Message-ID: <20130228184622.GA5500@redhat.com>
References: <20130224173144.GA32179@redhat.com> <20130225150534.269bacc4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225150534.269bacc4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25, Andrew Morton wrote:
>
> On Sun, 24 Feb 2013 18:31:44 +0100
> Oleg Nesterov <oleg@redhat.com> wrote:
>
> > Hello.
> >
> > On top of coredump-sanitize-the-setting-of-signal-group_exit_code.patch
> >
> > Andrew, "almost" means we need a bit more changes, but these
> > changes should be absolutely trivial/straightforward.
                      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Andrew, I lied :/

> Thanks.  I still have these marked "for 3.10".
>
> coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
> coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
> coredump-sanitize-the-setting-of-signal-group_exit_code.patch

Yes, thanks. But please drop the last series:

> coredump-factor-out-the-setting-of-pf_dumpcore.patch
> freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
> coredump-make-wait_for_dump_helpers-freezable.patch

As Mandeep pointed out (thanks!), this is not enough to make
dump_write/etc freezer-friendly.

I'll send another version.

Oleg.


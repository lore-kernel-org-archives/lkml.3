Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3BYXFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 18:05:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55808 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755402Ab3BYXFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 18:05:40 -0500
Date: Mon, 25 Feb 2013 15:05:34 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Mandeep Singh Baines <msb@chromium.org>, Neil Horman <nhorman@redhat.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/3] coredump: make it freezable (almost)
Message-Id: <20130225150534.269bacc4.akpm@linux-foundation.org>
In-Reply-To: <20130224173144.GA32179@redhat.com>
References: <20130224173144.GA32179@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 18:31:44 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

> Hello.
> 
> On top of coredump-sanitize-the-setting-of-signal-group_exit_code.patch
> 
> Andrew, "almost" means we need a bit more changes, but these
> changes should be absolutely trivial/straightforward. We need
> to add the killable/freezeng checks in dump_write/seek. But this
> depends on 2/3, lets discuss this series first.

Thanks.  I still have these marked "for 3.10".

coredump-only-sigkill-should-interrupt-the-coredumping-task.patch
coredump-ensure-that-sigkill-always-kills-the-dumping-thread.patch
coredump-sanitize-the-setting-of-signal-group_exit_code.patch
coredump-factor-out-the-setting-of-pf_dumpcore.patch
freezer-do-not-send-a-fake-signal-to-a-pf_dumpcore-thread.patch
coredump-make-wait_for_dump_helpers-freezable.patch


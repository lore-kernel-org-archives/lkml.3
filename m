Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaJOGcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 02:32:50 -0400
Received: from ozlabs.org ([103.22.144.67]:34104 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaJOGcr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 02:32:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, tiwai@suse.de, tj@kernel.org,
        arjan@linux.intel.com
Cc: teg@jklm.no, rmilasan@suse.com, werner@suse.com, oleg@redhat.com,
        hare@suse.com, bpoirier@suse.de, santosh@chelsio.com, pmladek@suse.cz,
        dbueso@suse.com, mcgrof@suse.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] taint: add TAINT_DEBUG for invasive debugging features
In-Reply-To: <1412372683-2003-2-git-send-email-mcgrof@do-not-panic.com>
References: <1412372683-2003-1-git-send-email-mcgrof@do-not-panic.com> <1412372683-2003-2-git-send-email-mcgrof@do-not-panic.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 15 Oct 2014 16:05:06 +1030
Message-ID: <87d29tc2ut.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Luis R. Rodriguez" <mcgrof@do-not-panic.com> writes:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> At times we may add module parameters or debugging / testing
> kernel features, when enabled though we don't really want
> to be spending time debugging them. Add a taint flag for
> this to avoid spurious bug reports.

The recently introduced KERNEL_PARAM_FL_UNSAFE flag for module
parameters does this explicitly.  It uses TAINT_USER, should it use
this instead?

Thanks,
Rusty.

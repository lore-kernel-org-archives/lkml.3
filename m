Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933864AbaHZHGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:06:17 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:44414 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbaHZHGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:06:15 -0400
Date: Tue, 26 Aug 2014 11:06:13 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Julien Tinnes <jln@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP
 operation, v4
Message-ID: <20140826070613.GB3063@moon>
References: <20140825100843.GM25918@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140825100843.GM25918@moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 02:08:43PM +0400, Cyrill Gorcunov wrote:
> During development of c/r we've noticed that in case if we need to
> support user namespaces we face a problem with capabilities in
> prctl(PR_SET_MM, ...) call, in particular once new user namespace
> is created capable(CAP_SYS_RESOURCE) no longer passes.

Hi guys, here is a small nit in this patch (missing linux/types.h inclusion
in prctl.h) as Stephen reported by linux-next build results. I've fixed it
in local quilt queue but defer sending to not flood lkml until there will
be no more concerns on the main code of the patch.

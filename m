Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaKTWVP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:21:15 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756764AbaKTWVO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:21:14 -0500
Date: Thu, 20 Nov 2014 14:21:12 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Richard Weinberger <richard@nod.at>
Cc: "Chen, Hanxiao" <chenhanxiao@cn.fujitsu.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Oleg Nesterov <oleg@redhat.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mateusz Guzik <mguzik@redhat.com>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v8 1/2] procfs: show hierarchy of pid namespace
Message-Id: <20141120142112.74b490298d3360e53dc3169a@linux-foundation.org>
In-Reply-To: <546E5D46.4070805@nod.at>
References: <1416303013-13762-1-git-send-email-chenhanxiao@cn.fujitsu.com>
	<1416303013-13762-2-git-send-email-chenhanxiao@cn.fujitsu.com>
	<5871495633F38949900D2BF2DC04883E73748A47@G08CNEXMBPEKD03.g08.fujitsu.local>
	<546E5D46.4070805@nod.at>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 22:29:42 +0100 Richard Weinberger <richard@nod.at> wrote:

> > 
> > Any comments?
> 
> FWIW, Acked-by: Richard Weinberer <richard@nod.at>
> 
> The more challenging question is who will pickup this series?
> Eric? Andrew?

I can monkey the patches but I'd very much like to hear Eric's comments.

Also the CRIU people.  How is CRIU presently reassembling these
relationships?

Serge, what was your take on the usefulness/applicability of this work?
IOW, why the ack?

The patchset doesn't touch Documentation/.  That will need to be fixed,
please.  The new interfaces should be completely described in the
kernel documentation.

The new code appears to be included when CONFIG_PID_NS=n.  Is there any
point in doing that?

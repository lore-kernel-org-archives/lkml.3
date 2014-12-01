Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754175AbaLAWjQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 17:39:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51845 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754026AbaLAWjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 17:39:14 -0500
Date: Mon, 1 Dec 2014 14:39:13 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Aaron Tomlin <atomlin@redhat.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@ubuntu.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] exit: pidns: fix/update the comments in
 zap_pid_ns_processes()
Message-Id: <20141201143913.8780d386f9ad3ef87aeadd17@linux-foundation.org>
In-Reply-To: <20141126235437.GA386@redhat.com>
References: <20141126235416.GA32688@redhat.com>
	<20141126235437.GA386@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Nov 2014 00:54:37 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> The comments in zap_pid_ns_processes() are not clear, we need to
> explain how this code actually works.

Could we please get some documentation for PIDNS_HASH_ADDING?  What it
does, what is the protocol for handling it, etc?  I was trying to
review your [1/2] but this little mystery has me somewhat stumped.

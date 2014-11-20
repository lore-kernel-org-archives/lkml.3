Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbaKTWhZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 17:37:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:47465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409AbaKTWhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 17:37:24 -0500
Date: Thu, 20 Nov 2014 14:37:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Aaron Tomlin <atomlin@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sterling Alexander <stalexan@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 1/3] exit: reparent: avoid find_new_reaper() if no
 children
Message-Id: <20141120143722.af15074e6922108962e84649@linux-foundation.org>
In-Reply-To: <20141120183423.GA10270@redhat.com>
References: <20141120183400.GA9622@redhat.com>
	<20141120183423.GA10270@redhat.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Nov 2014 19:34:23 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> $ time ./test 16 16536 shows:
> 
> 		real		user		sys
> 	-	5m37.628s	0m4.437s	8m5.560s
> 	+	0m50.032s	0m7.130s	1m4.927s

Is that the best you can do?

(I assume the increase in user time was a glitch?)

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753687Ab3C0PeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 11:34:20 -0400
Received: from r00tworld.com ([212.85.137.150]:35649 "EHLO r00tworld.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752683Ab3C0PeS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 11:34:18 -0400
X-Greylist: delayed 2435 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Mar 2013 11:34:18 EDT
From: "PaX Team" <pageexec@freemail.hu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Luis Henriques <luis.henriques@canonical.com>
Date: Wed, 27 Mar 2013 15:53:25 +0100
MIME-Version: 1.0
Subject: Re: [PATCH 150/150] kernel/signal.c: use __ARCH_HAS_SA_RESTORER instead of SA_RESTORER
Reply-to: pageexec@freemail.hu
CC: Emese Revfy <re.emese@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Julien Tinnes <jln@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Message-ID: <515307E5.8858.4BC860B3@pageexec.freemail.hu>
X-mailer: Pegasus Mail for Windows (4.63)
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.1.12 (r00tworld.com [212.85.137.150]); Wed, 27 Mar 2013 15:53:29 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sorry if you got this twice, had smtpd problems...

On 26 Mar 2013 at 15:20, Luis Henriques wrote:

> 3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andrew Morton <akpm@linux-foundation.org>
> 
> commit 522cff142d7d2f9230839c9e1f21a4d8bcc22a4a upstream.
> 
> __ARCH_HAS_SA_RESTORER is the preferred conditional for use in 3.9 and
> later kernels, per Kees.

does __ARCH_HAS_SA_RESTORER exist in the 3.5 stable series at all? i thought it
was new to 3.9...




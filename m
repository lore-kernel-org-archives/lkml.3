Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751468Ab3LJA0C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 19:26:02 -0500
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:41900 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751123Ab3LJAZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 19:25:58 -0500
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 19:25:58 EST
Message-ID: <1386634788.24817.46.camel@rhapsody>
Subject: Re: [PATCH] kexec: add sysctl to disable kexec
From: Khalid Aziz <khalid@gonehiking.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        kexec@lists.infradead.org, Eric Biederman <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Mel Gorman <mgorman@suse.de>
Date: Mon, 09 Dec 2013 17:19:48 -0700
In-Reply-To: <20131209233829.GA3501@www.outflux.net>
References: <20131209233829.GA3501@www.outflux.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-12-09 at 15:38 -0800, Kees Cook wrote:
> For general-purpose (i.e. distro) kernel builds it makes sense to build with
> CONFIG_KEXEC to allow end users to choose what kind of things they want to do
> with kexec. However, in the face of trying to lock down a system with such
> a kernel, there needs to be a way to disable kexec (much like module loading
> can be disabled). Without this, it is too easy for the root user to modify
> kernel memory even when CONFIG_STRICT_DEVMEM and modules_disabled are set.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Giving Sys admins more control to secure their system is a good idea.
This addition looks good to me.

--
Khalid


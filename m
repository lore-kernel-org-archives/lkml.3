Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752034AbaAOBeW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:34:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbaAOBeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:34:20 -0500
Date: Tue, 14 Jan 2014 17:34:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>
Subject: Re: [PATCH v2 0/4]zram: locking redesign
Message-Id: <20140114173419.3122b69f2bbb1a311bfa65a2@linux-foundation.org>
In-Reply-To: <20140115012948.GE1992@bbox>
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
	<20140115012948.GE1992@bbox>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Jan 2014 10:29:48 +0900 Minchan Kim <minchan@kernel.org> wrote:

> Oops, I missed Tested-by from Sergey. Really, sorry.
> If I have a chance to resend from any review, I will add. Otherwise,
> Andrew, Could you add his tested-by?

Sure.

I normally wouldn't consider such a patchset this late in the kernel
cycle.  But these patches speeds up some writes by 10x and zram is
officially still in staging/.  So I guess we could squeak these into
3.14.

Prompt review and testing by others would be appreciated, please.

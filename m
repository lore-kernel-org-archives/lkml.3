Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab3JHUG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 16:06:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44066 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHUGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 16:06:25 -0400
Date: Tue, 8 Oct 2013 13:06:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] Soft dirty tracking fixes
Message-Id: <20131008130624.d7c50cef20d968e8c0484a41@linux-foundation.org>
In-Reply-To: <20131008200224.GB19040@moon>
References: <20131008090019.527108154@gmail.com>
	<20131008125013.85dcccf418260d43b6cb120a@linux-foundation.org>
	<20131008200224.GB19040@moon>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Oct 2013 00:02:24 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> On Tue, Oct 08, 2013 at 12:50:13PM -0700, Andrew Morton wrote:
> > 
> > Do you consider the problems which patches 1 and 2 address to be
> > sufficiently serious to justify backporting into -stable?
> 
> Good question! Yeah, since dirty bit traking is in 3.11 already,
> it would be great to merge these two patches into -stable.

OK.

> Should I resend them with stable team CC'ed?

Nope, I added cc:stable to the changelogs so they should receive
consideration by Greg automatically.


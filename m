Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3JHTuQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 15:50:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44034 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751896Ab3JHTuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 15:50:14 -0400
Date: Tue, 8 Oct 2013 12:50:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 0/3] Soft dirty tracking fixes
Message-Id: <20131008125013.85dcccf418260d43b6cb120a@linux-foundation.org>
In-Reply-To: <20131008090019.527108154@gmail.com>
References: <20131008090019.527108154@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 08 Oct 2013 13:00:19 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Hi! Here is a couple of fixes for soft dirty pages tracking.
> While first two patches are adressing issues, the last one
> is rather a cleanup which I've been asked to implement long
> ago, but I'm not sure if anyone picked it up.
> 

Do you consider the problems which patches 1 and 2 address to be
sufficiently serious to justify backporting into -stable?

I already have patch 3, as
arch-x86-mnify-pte_to_pgoff-and-pgoff_to_pte-helpers.patch (with
s/m/u).  I've queued it for transmission to the x86 guys.

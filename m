Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392Ab3I0URm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 16:17:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab3I0URj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 16:17:39 -0400
Date: Fri, 27 Sep 2013 13:18:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jingoo Han <jg1.han@samsung.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] kernel: replace strict_strto*() with kstrto*()
Message-Id: <20130927131820.7fc04051.akpm@linux-foundation.org>
In-Reply-To: <20130927195353.3643398a@endymion.delvare>
References: <000401ce86b7$0463f580$0d2be080$@samsung.com>
	<CAErSpo51GFB+yCuaHrwBqWjHxd0GboHgvWGov5pj4V6aGPfQHg@mail.gmail.com>
	<20130927195353.3643398a@endymion.delvare>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013 19:53:53 +0200 Jean Delvare <khali@linux-fr.org> wrote:

> Andrew,
> 
> On Fri, 27 Sep 2013 09:50:39 -0600, Bjorn Helgaas wrote:
> > There's some indication that this change might have broken handling of
> > signed types.  See
> > https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-September/111758.html
> > and https://bugzilla.kernel.org/show_bug.cgi?id=61811.
> 
> It seems this is hurting more users than I would have expected, and
> people are spending significant amounts of time to figure out what the
> root cause to their problem is. May I suggest that my fix should find
> its way to Linus' tree rather sooner than later?
> 

Done.  I had to send that one by hand as I'm not at my desk...

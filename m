Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599AbaGHUTX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 16:19:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36022 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754266AbaGHUTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 16:19:21 -0400
Date: Tue, 8 Jul 2014 13:19:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [PATCH] mm: Don't forget to set softdirty on file mapped fault
Message-Id: <20140708131920.2a857d573e8cc89780c9fa1c@linux-foundation.org>
In-Reply-To: <20140708192151.GD17860@moon.sw.swsoft.com>
References: <20140708192151.GD17860@moon.sw.swsoft.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014 23:21:51 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> Otherwise we may not notice that pte was softdirty because pte_mksoft_dirty
> helper _returns_ new pte but not modifies argument.

When fixing a bug, please describe the end-user visible effects of that
bug.

[for the 12,000th time :(]

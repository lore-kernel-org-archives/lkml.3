Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbaAVTwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 14:52:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788AbaAVTwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 14:52:16 -0500
Date: Wed, 22 Jan 2014 11:52:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, gnome@rvzt.net,
        drawoc@darkrefraction.com, alan@lxorguk.ukuu.org.uk,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 67651] Bisected: Lots of fragmented mmaps cause gimp to
 fail in 3.12 after exceeding vm_max_map_count
Message-Id: <20140122115215.f723ddf2e2a3c3d4b6ab9bf3@linux-foundation.org>
In-Reply-To: <20140122190816.GB4963@suse.de>
References: <20140122190816.GB4963@suse.de>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Jan 2014 19:08:16 +0000 Mel Gorman <mgorman@suse.de> wrote:

> X-related junk is there was because I was using a headless server and
> xinit directly to launch gimp to reproduce the bug.

I've never done this.  Can you share the magic recipe for running an X
app in this way?

Thanks.

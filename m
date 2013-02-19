Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932453Ab3BSJPS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 04:15:18 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:48004 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3BSJPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 04:15:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 19 Feb 2013 10:15:02 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Tim Gardner <tim.gardner@canonical.com>
Cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
Subject: Re: [PATCH linux-next v2] firewire: fw_device_init: 'minor' may be
 used uninitialized
Message-ID: <20130219101502.18a51c0b@stein>
In-Reply-To: <1361222676-113069-1-git-send-email-tim.gardner@canonical.com>
References: <1361222343-112898-1-git-send-email-tim.gardner@canonical.com>
	<1361222676-113069-1-git-send-email-tim.gardner@canonical.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 18 Tim Gardner wrote:
> 'firewire: convert to idr_alloc()' accidentally orphaned 'minor'.
[...]
> If this patch is correct, then it also ought to go to stable
> if it misses 3.8 final.

"firewire: convert to idr_alloc()" is pending for merge after 3.8/
before 3.9-rc1, IOW 3.8 is not affected.  (I notified akpm who handles the
faulty patch.)
-- 
Stefan Richter
-=====-===-= --=- =--==
http://arcgraph.de/sr/

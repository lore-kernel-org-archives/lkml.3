Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab3BDUvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 15:51:39 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab3BDUvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 15:51:38 -0500
Date: Mon, 4 Feb 2013 12:51:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        xfs@oss.sgi.com, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH 10/18] mm: teach truncate_inode_pages_range() to handle
 non page aligned ranges
Message-Id: <20130204125136.b0926f20.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1302041510090.3225@localhost>
References: <1359715424-32318-1-git-send-email-lczerner@redhat.com>
	<1359715424-32318-11-git-send-email-lczerner@redhat.com>
	<20130201151502.59398b29.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1302041510090.3225@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Feb 2013 15:51:19 +0100 (CET)
Luk____ Czerner <lczerner@redhat.com> wrote:

> I hope I explained myself well enough :). Are you ok with this king
> of approach ? If so, I'll resend the patch set without the
> initialisation-at-declaration.

uh, maybe.  Next time I'll apply the patch and look at the end result! 
Try to make it as understandable and (hence) maintainable as possible,
OK?


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693Ab3ARKXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:23:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:46409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011Ab3ARKXC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:23:02 -0500
MIME-Version: 1.0
In-Reply-To: <20130117135726.5b31fd0f.akpm@linux-foundation.org>
References: <1357352744-8138-1-git-send-email-ming.lei@canonical.com>
	<20130116153744.70210fa3.akpm@linux-foundation.org>
	<CACVXFVOipr0VMyPQaZTLckxTaPan7ZneERUqZ1S_mYo11A5AeA@mail.gmail.com>
	<20130117135726.5b31fd0f.akpm@linux-foundation.org>
Date: Fri, 18 Jan 2013 18:22:59 +0800
Message-ID: <CACVXFVPEcZCCxA1+EeW-qdouiaBMPPjx7fn+jbROzSwBRN58SA@mail.gmail.com>
Subject: Re: [PATCH v7 0/6] solve deadlock caused by memory allocation with I/O
From: Ming Lei <ming.lei@canonical.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 5:57 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
>
> Fair enough, thanks.
>
> I grabbed the patches for 3.9-rc1.  It is good that the page
> allocator's newly-added test of current->flags is not on the fastpath.
>

Andrew, great thanks, :-)

Also thank Alan, Oliver, Minchan, Rafael, Greg and other guys who
reviewed and gave suggestions on this patch set.

Thanks,
--
Ming Lei

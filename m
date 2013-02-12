Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab3BLVnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 16:43:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54616 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146Ab3BLVnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 16:43:51 -0500
Date: Tue, 12 Feb 2013 13:43:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, nbd-general@lists.sf.net,
        Paul Clements <Paul.Clements@steeleye.com>
Subject: Re: [PATCH 0/3] NBD fixes for caching and block device flags
Message-Id: <20130212134349.579be89a.akpm@linux-foundation.org>
In-Reply-To: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Feb 2013 17:06:08 +0100
Paolo Bonzini <pbonzini@redhat.com> wrote:

> The first two patches improve the behavior of NBD with respect to the host
> cache---respectively the server's cache and the client's.  The first adds
> support for flushing the backing storage, so that NBD is safe against
> power losses.  The second properly syncs and cleans the client's page
> cache when an NBD device is disconnected from the server.
> 
> The third reports read-only devices properly in sysfs.
> 
> Ok for 3.9?  I saw the last NBD patches were applied by Andrew Morton,
> so I'm CCing him; Paul, please ack them if they are okay.

I grabbed these and will await Paul's feedback, and a bit more
changelog detail for [1/3], please.


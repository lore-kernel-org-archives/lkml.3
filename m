Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933904Ab3LIQLV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:11:21 -0500
Received: from b232-131.smtp-out.amazonses.com ([199.127.232.131]:15882 "EHLO
	b232-131.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932706Ab3LIQLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:11:20 -0500
Date: Mon, 9 Dec 2013 16:11:19 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "ethan.zhao" <ethan.kernel@gmail.com>
cc: alokk@calsoftinc.com, shobhit@calsoftinc.com, shai@scalex86.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/slab.c: check pointer slabp before using it in
 alloc_slabmgmt()
In-Reply-To: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
Message-ID: <00000142d82085d4-edeac9e1-d603-458f-9ceb-904e2b706679-000000@email.amazonses.com>
References: <1386495533-413-1-git-send-email-ethan.kernel@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.127.232.131
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Dec 2013, ethan.zhao wrote:

> Move the NULL check of slabp to the right place before refer its memeber in
> function alloc_slabmgmt().

I am having trouble to find the code you are modifying. Which kernel
release is this? The code you are referring to has been rewritten in the
meantime or this is some other code basis.


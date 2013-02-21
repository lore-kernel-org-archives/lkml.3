Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841Ab3BUVtJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 16:49:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab3BUVtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 16:49:06 -0500
Date: Thu, 21 Feb 2013 13:49:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: =?UTF-8?Q?Luk=C3=A1=C5=A1?= Czerner <lczerner@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2 10/18] mm: teach truncate_inode_pages_range() to
 handle non page aligned ranges
Message-Id: <20130221134905.9a1e2c9e.akpm@linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1302210929590.19354@localhost>
References: <1360055531-26309-1-git-send-email-lczerner@redhat.com>
	<1360055531-26309-11-git-send-email-lczerner@redhat.com>
	<20130207154042.92430aed.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1302080948110.3225@localhost>
	<alpine.LFD.2.00.1302210929590.19354@localhost>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Feb 2013 09:33:56 +0100 (CET)
Luk____ Czerner <lczerner@redhat.com> wrote:

> what's the status of the patch set ?

Forgotten about :(

> Can we get this in in this merge window ?

Please do a full resend after 3.9-rc1 and let's take it up again.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762972Ab3JQVNm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 17:13:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762765Ab3JQVNi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 17:13:38 -0400
Date: Thu, 17 Oct 2013 14:13:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mike Miller <mike.miller@hp.com>
Cc: Jens Axboe <axboe@kernel.dk>, LKML-scsi <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] remove cpqarray from mainline kernel
Message-Id: <20131017141337.425f84c630ffe1c7c61c4dc4@linux-foundation.org>
In-Reply-To: <20131017175226.GA31535@thumper.usa.hp.com>
References: <20131017175226.GA31535@thumper.usa.hp.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 12:52:26 -0500 Mike Miller <mike.miller@hp.com> wrote:

> cpqarray hasn't been used in over 12 years. It's doubtful that anyone still
> uses the board. It's time the driver was removed from the mainline kernel.
> The only updates these days are minor and mostly done by people outside of HP.

It's amazing the weird stuff people get up to.  Perhaps we should disable
it in config for a cycle or two, see if that flushes anyone out?

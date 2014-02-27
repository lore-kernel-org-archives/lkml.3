Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaB0XWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 18:22:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40463 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaB0XWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 18:22:18 -0500
Date: Thu, 27 Feb 2014 15:22:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>, Jerome Marchand <jmarchan@redhat.com>,
        Nitin Gupta <ngupta@vflare.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv8 4/6] zram: add multi stream functionality
Message-Id: <20140227152217.c98766447d82f80262e509b0@linux-foundation.org>
In-Reply-To: <1393417679-13657-5-git-send-email-sergey.senozhatsky@gmail.com>
References: <1393417679-13657-1-git-send-email-sergey.senozhatsky@gmail.com>
	<1393417679-13657-5-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Feb 2014 15:27:57 +0300 Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> This patch implements multi stream compression support.

um, what is "multi stream compression".  Please define this term fully.

It's not immediately clear what the advantage is.  How does this
feature benefit our users?



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbbAZXTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:19:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbAZXTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:19:44 -0500
Date: Mon, 26 Jan 2015 15:19:42 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: minchan@kernel.org, ngupta@vflare.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zsmalloc: add log for module load/unload
Message-Id: <20150126151942.2dd88d5221423e7379b43a06@linux-foundation.org>
In-Reply-To: <1422107321-9973-1-git-send-email-opensource.ganesh@gmail.com>
References: <1422107321-9973-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Jan 2015 21:48:41 +0800 Ganesh Mahendran <opensource.ganesh@gmail.com> wrote:

> Sometimes, we want to know whether a module is loaded or unloaded
> from the log.

Why?  What's special about zsmalloc?

Please provide much better justification than this.

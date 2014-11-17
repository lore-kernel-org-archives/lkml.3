Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753481AbaKQXIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 18:08:24 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52030 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbaKQXIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 18:08:23 -0500
Date: Mon, 17 Nov 2014 15:08:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhihui Zhang <zzhsuny@gmail.com>
Cc: mgorman@suse.de, oleg@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [mempolicy] remove unnecessary is_valid_nodemask()
Message-Id: <20141117150821.45ac5aa8dca4b43392f563a8@linux-foundation.org>
In-Reply-To: <1416106197-8784-1-git-send-email-zzhsuny@gmail.com>
References: <1416106197-8784-1-git-send-email-zzhsuny@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 Nov 2014 21:49:57 -0500 Zhihui Zhang <zzhsuny@gmail.com> wrote:

> When nodes is true, nsc->mask2 has already been filtered by nsc->mask1, which has
> already factored in node_states[N_MEMORY].
> 

Please be more specific.  Where does that filtering occur?


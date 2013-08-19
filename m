Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751781Ab3HSXFp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:05:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55303 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419Ab3HSXFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:05:44 -0400
Date: Mon, 19 Aug 2013 16:05:42 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arun KS <arunks.linux@gmail.com>
Cc: viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>,
        Bruce Fields <bfields@fieldses.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vinayak menon <vinayakm.list@gmail.com>,
        Nagachandra P <nagachandra@gmail.com>, Vikram MP <mp.vikram@gmail.com>
Subject: Re: [PATCH] SeqFile: Fix overflow condition
Message-Id: <20130819160542.38e4a91b568c0a15f1068e09@linux-foundation.org>
In-Reply-To: <CAKZGPAOwpEcxxZJUbmUVL1J+enXGhFbbvyZ7L3uWDkPbwKnbyQ@mail.gmail.com>
References: <CAKZGPAOwpEcxxZJUbmUVL1J+enXGhFbbvyZ7L3uWDkPbwKnbyQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013 17:02:37 +0530 Arun KS <arunks.linux@gmail.com> wrote:

> seq_path()/seq_commit() is treating a d_path() failure as an overflow
> condition, but it isn't.

This is too brief.  When fixing a bug please always describe the
user-visible effects of the bug.  And unless it's utterly obvious,
provide a description of how you set about fixing that bug.


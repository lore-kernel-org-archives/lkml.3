Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568AbaIAPgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 11:36:43 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41171 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbaIAPgk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 11:36:40 -0400
Date: Mon, 1 Sep 2014 16:36:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Rob Jones <rob.jones@codethink.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, linux-kernel@codethink.co.uk
Subject: Re: [PATCH] fs: replace int param with size_t for seq_open_private()
Message-ID: <20140901153637.GI7996@ZenIV.linux.org.uk>
References: <1409577428-16148-1-git-send-email-rob.jones@codethink.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409577428-16148-1-git-send-email-rob.jones@codethink.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 02:17:08PM +0100, Rob Jones wrote:

>  void *__seq_open_private(struct file *f, const struct seq_operations *ops,
> -		int psize)
> +		size_t psize)

<sarcasm>
It is a horrible limitation to impose, indeed.  Why, a lousy
2 gigabytes per line in procfs file - that's intolerable...
</sarcasm> 

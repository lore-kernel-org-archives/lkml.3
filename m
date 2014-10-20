Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbaJTVxd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 17:53:33 -0400
Received: from g4t3426.houston.hp.com ([15.201.208.54]:6082 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023AbaJTVxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 17:53:31 -0400
Date: Mon, 20 Oct 2014 16:43:02 -0500
From: relliott@beardog.cce.hp.com
To: Robert Elliott <elliott@hp.com>
Cc: axboe@kernel.dk, webbnh@hp.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, viro@zeniv.linux.org.uk,
        scameron@beardog.cce.hp.com
Subject: Re: [PATCH 0/2] fs: merge I/O error prints into one line
Message-ID: <20141020214302.GB3467@beardog.cce.hp.com>
References: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140827155036.32144.56190.stgit@beardog.cce.hp.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 27, 2014 at 10:51:54AM -0500, Robert Elliott wrote:
> The following series merges I/O error prints into one
> line and makes rate limited messages clearer.
> 
> ---
> 
> Robert Elliott (2):
>       fs: merge I/O error prints into one line
>       fs: clarify rate limit suppressed buffer I/O errors
> 
> 
>  fs/buffer.c |   38 +++++++++-----------------------------
>  1 files changed, 9 insertions(+), 29 deletions(-)
> 
> -- 
> Rob Elliott, HP Server Storage  elliott@hp.com

ping

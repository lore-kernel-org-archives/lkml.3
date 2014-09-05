Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932608AbaIEOCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:02:10 -0400
Received: from mail-qa0-f45.google.com ([209.85.216.45]:56553 "EHLO
	mail-qa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932422AbaIEOCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:02:08 -0400
From: Jeff Layton <jeff.layton@primarydata.com>
X-Google-Original-From: Jeff Layton <jlayton@primarydata.com>
Date: Fri, 5 Sep 2014 10:02:04 -0400
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org,
        "J. Bruce Fields" <bfields@fieldses.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 12/17] locks: update Documentation/filesystems with
 new setlease semantics
Message-ID: <20140905100204.0937ad89@tlielax.poochiereds.net>
In-Reply-To: <20140904175043.GF16935@infradead.org>
References: <1409834323-7171-1-git-send-email-jlayton@primarydata.com>
	<1409834323-7171-13-git-send-email-jlayton@primarydata.com>
	<20140904175043.GF16935@infradead.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Sep 2014 10:50:43 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> Looks good, but I'd rather merge it into the patch that changes the
> semantics.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Fair enough. I'll merge the changes to the Documentation in with the
patches that change them.

-- 
Jeff Layton <jlayton@primarydata.com>

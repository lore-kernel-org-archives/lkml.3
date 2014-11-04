Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaKDKAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:00:43 -0500
Received: from verein.lst.de ([213.95.11.211]:51064 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752681AbaKDJzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:55:13 -0500
Date: Tue, 4 Nov 2014 10:55:11 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] fs: Remove i_devices list head
Message-ID: <20141104095511.GD17722@lst.de>
References: <1414008853-13200-1-git-send-email-jack@suse.cz> <1414008853-13200-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414008853-13200-5-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 22, 2014 at 10:14:13PM +0200, Jan Kara wrote:
> Noone uses i_devices anymore. Remove it (thus saving two pointers in
> every inode).

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

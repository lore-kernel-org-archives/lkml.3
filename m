Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683AbaKDJyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 04:54:52 -0500
Received: from verein.lst.de ([213.95.11.211]:51060 "EHLO newverein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDJyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 04:54:49 -0500
Date: Tue, 4 Nov 2014 10:54:47 +0100
From: Christoph Hellwig <hch@lst.de>
To: Jan Kara <jack@suse.cz>
Cc: Al Viro <viro@ZenIV.linux.org.uk>, hch@lst.de,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] chardev: Don't use i_devices inode field
Message-ID: <20141104095447.GC17722@lst.de>
References: <1414008853-13200-1-git-send-email-jack@suse.cz> <1414008853-13200-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414008853-13200-4-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

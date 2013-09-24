Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754533Ab3IXQtX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 12:49:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60609 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3IXQtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 12:49:20 -0400
Date: Tue, 24 Sep 2013 17:49:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Lubomir Rintel <lkundrak@v3.sk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sysv: Add forgotten superblock lock init for v7 fs
Message-ID: <20130924164917.GX13318@ZenIV.linux.org.uk>
References: <1379457556-8902-1-git-send-email-lkundrak@v3.sk>
 <20130924085022.GD11858@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130924085022.GD11858@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 01:50:22AM -0700, Christoph Hellwig wrote:

> Al, can you add this to the next VFS pile?

Applied.

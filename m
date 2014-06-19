Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966494AbaFSXfM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 19:35:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52854 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965786AbaFSXfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 19:35:11 -0400
Date: Thu, 19 Jun 2014 16:39:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Vincent Heuken <me@vincentheuken.com>
Cc: willy@meta-x.org, monamagarwal123@gmail.com, arnd@arndb.de,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: panel: fixed checkpatch errors in panel.c
Message-ID: <20140619233911.GA3388@kroah.com>
References: <1401618055-24546-1-git-send-email-me@vincentheuken.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401618055-24546-1-git-send-email-me@vincentheuken.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 03:20:55AM -0700, Vincent Heuken wrote:
> This patch simply fixes the style errors in panel.c
> that scripts/checkpatch.pl reported

Which style errors?  Please be specific.

And break the patch up into only doing one type of fix at a time,
otherwise it's hard to review.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934955Ab3DISYq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:24:46 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:35878 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3DISYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:24:45 -0400
Date: Tue, 9 Apr 2013 19:24:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Andrey Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] mnt: release locks on error path in do_loopback
Message-ID: <20130409182443.GB4068@ZenIV.linux.org.uk>
References: <1365514409-12448-1-git-send-email-avagin@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365514409-12448-1-git-send-email-avagin@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 09, 2013 at 05:33:29PM +0400, Andrey Vagin wrote:
> do_loopback calls lock_mount(path) and forget to unlock_mount
> if clone_mnt or copy_mnt fails.

Applied.

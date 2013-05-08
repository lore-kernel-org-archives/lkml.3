Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757266Ab3EHUfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 16:35:51 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:59173 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426Ab3EHUfu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 16:35:50 -0400
Date: Wed, 8 May 2013 21:35:48 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ben Greear <greearb@candelatech.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: relayfs question related to removing parent directory.
Message-ID: <20130508203547.GX25399@ZenIV.linux.org.uk>
References: <518AB646.1000406@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <518AB646.1000406@candelatech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 01:32:06PM -0700, Ben Greear wrote:
> I'm seeing a crash when unloading the ath9k module.
> 
> It seems relay_close() is being passed bad memory.
> 
> The relay_open call uses an ath9k debugfs directory, so
> that may be removed before the call to relay_close()
> is called.
> 
> Does relayfs automatically close files when the parent
> directory is removed?

Why and how the hell would it possibly manage such a miracle?

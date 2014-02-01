Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429AbaBARxh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Feb 2014 12:53:37 -0500
Received: from palinux.external.hp.com ([192.25.206.14]:32891 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933167AbaBARxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Feb 2014 12:53:36 -0500
Date: Sat, 1 Feb 2014 10:53:34 -0700
From: Matthew Wilcox <matthew@wil.cx>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, jack@suse.cz, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 1/1] ext2: Add __init macro to init_inodecache
Message-ID: <20140201175334.GJ20939@parisc-linux.org>
References: <20140201160202.a3ac96c613754013300b462d@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140201160202.a3ac96c613754013300b462d@skynet.be>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 01, 2014 at 04:02:02PM +0800, Fabian Frederick wrote:
> init_inodecache is only called by __init init_ext2_fs.

Looks like this is true for the majority of filesystems.  Would you care
to submit more patches?  :-)

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

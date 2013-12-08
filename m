Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759994Ab3LHWKN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 17:10:13 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:56724 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3LHWKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 17:10:11 -0500
Date: Sun, 8 Dec 2013 22:10:08 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: proc: lockdep spew and questions
Message-ID: <20131208221008.GO10323@ZenIV.linux.org.uk>
References: <52A4DD51.6090709@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52A4DD51.6090709@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 08, 2013 at 03:57:53PM -0500, Sasha Levin wrote:
> Hi all,
> 
> I've been looking at permissions in procfs, and noticed that
> directories are usually added with execute permission.
> 
> As far as I know, there's nothing executable by default inside
> procfs, and on top of that, many of the files there don't deal well
> with being executed so it's easy to cause lockdep spews (one below).
> 
> Is there a reason execute bit is set for directories?

Take any introductory textbook on Unix and read the chapter on permissions.
Or say chmod a-x ~, if you prefer education by self-LART...

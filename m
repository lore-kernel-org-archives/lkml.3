Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933075Ab3LILye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 06:54:34 -0500
Received: from trent.utfs.org ([94.185.90.103]:46033 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759450Ab3LILyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 06:54:32 -0500
X-Greylist: delayed 453 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Dec 2013 06:54:32 EST
Date: Mon, 9 Dec 2013 03:46:54 -0800 (PST)
From: Christian Kujau <lists@nerdbynature.de>
To: Sasha Levin <sasha.levin@oracle.com>
cc: Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: fs: proc: lockdep spew and questions
In-Reply-To: <52A5357A.8030506@oracle.com>
Message-ID: <alpine.DEB.2.11.1312090341520.31521@trent.utfs.org>
References: <52A4DD51.6090709@oracle.com> <20131208221008.GO10323@ZenIV.linux.org.uk> <52A5357A.8030506@oracle.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Dec 2013 at 22:14, Sasha Levin wrote:
> So how would you suggest to deal with the execution issue in procfs?

Files will not be executable by itsself if /proc is mounted with noexec, 
as some distributions now do by default.

C.
-- 
BOFH excuse #14:

sounds like a Windows problem, try calling Microsoft support

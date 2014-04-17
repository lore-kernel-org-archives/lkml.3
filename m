Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751474AbaDQV25 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 17:28:57 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:36149 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001AbaDQV2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 17:28:39 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Thu, 17 Apr 2014 17:28:34 -0400
To: Jos Huisken <jos.huisken@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: inotify, new idea?
Message-ID: <20140417212834.GC17769@csclub.uwaterloo.ca>
References: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOiKX_m8buaq=4_hVQjyfv36ZtFVFieZ-CU8JeDpcdbeiX5mug@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 11:00:37PM +0200, Jos Huisken wrote:
> I was trying to maintain a local and remote directory in sync with
> lsync, using inotify.
> I happen to have >4M files and >400k directories... running over
> /proc/sys/fs/inotify/max_user_watches

Would fanotify perhaps be a better interface to use?

-- 
Len Sorensen

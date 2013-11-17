Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753753Ab3KQDVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 22:21:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19273 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753031Ab3KQDVd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 22:21:33 -0500
Date: Sat, 16 Nov 2013 22:21:19 -0500
From: Dave Jones <davej@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] sysfs: use a separate locking class for open files
 depending on mmap
Message-ID: <20131117032119.GA26529@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Tejun Heo <tj@kernel.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20131113184538.GA7269@redhat.com>
 <20131113201043.GE13318@ZenIV.linux.org.uk>
 <20131114054116.GC29031@mtj.dyndns.org>
 <20131115011916.GA19453@redhat.com>
 <20131117021736.GA9302@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131117021736.GA9302@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 17, 2013 at 11:17:36AM +0900, Tejun Heo wrote:

 
 > +	if (has_mmap)
 > +		mutex_init(&of->mutex);
 > +	else
 > +		mutex_init(&of->mutex);

ummm...

	Dave

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbaGBOqM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:46:12 -0400
Received: from moi001.1and1.com ([212.227.126.208]:60869 "EHLO moi.1and1.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547AbaGBOqK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:46:10 -0400
X-Greylist: delayed 544 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 Jul 2014 10:46:10 EDT
Message-ID: <53B418FA.80600@1und1.de>
Date: Wed, 02 Jul 2014 16:36:42 +0200
From: =?ISO-8859-1?Q?Thomas_Sch=F6bel-Theuer?= <tst@1und1.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>
CC: Thomas Schoebel-Theuer <tst@schoebel-theuer.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 49/50] mars: generic pre-patch for mars
References: <1404251250-22992-1-git-send-email-tst@schoebel-theuer.de> <1404251250-22992-50-git-send-email-tst@schoebel-theuer.de> <20140701223644.GA30330@kroah.com> <53B3B283.7050800@schoebel-theuer.de> <20140702082400.GB10971@kroah.com> <20140702132708.GA26732@infradead.org>
In-Reply-To: <20140702132708.GA26732@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Using syscalls or syscall-like functionality from kernel code
> generally is a bad idea. Every single use needs a clear rationale in
> the patch description. Which do not seem to exist at all for the
> series, so in it's current form it'll go straight to the trash bin anyway.

Thanks, Christoph, for the explanation. I have been so long away from
the community that I don't remember all conventions / preferences any more.

Please, could you kindly advise me in the following dilemma:

Now there exists a vfs_rmdir() which I would gladly prefer in order to
avoid EXPORT_SYMBOL(sys_rmdir).

However, I probably would have to "borrow" large parts of the
sys_rmdir() implementation from fs/namei.c (the only real difference
appears to me that the pathname is not in userspace).

So, what is worse: copying relatively large pieces of code, or using
sys_rmdir()?

Thanks,

Thomas


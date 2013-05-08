Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754703Ab3EHCy0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 22:54:26 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:51678 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3EHCyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 22:54:24 -0400
Date: Tue, 7 May 2013 19:54:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Chen Gang <gang.chen@asianux.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] Drivers: Misc: fix warnings, unsigned long will never
 < 0
Message-ID: <20130508025422.GA3888@kroah.com>
References: <5160E37C.3020007@asianux.com>
 <5160E7EA.3050406@asianux.com>
 <5189B76C.9050606@asianux.com>
 <20130508023803.GB19842@kroah.com>
 <5189BCA1.1090105@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5189BCA1.1090105@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 08, 2013 at 10:46:57AM +0800, Li Zefan wrote:
> On 2013/5/8 10:38, Greg KH wrote:
> > On Wed, May 08, 2013 at 10:24:44AM +0800, Chen Gang wrote:
> >> Hello Maintainers:
> >>
> >> Please help check, when you have time.
> >>
> >> Thanks.
> >>
> >> On 2013年04月07日 11:28, Chen Gang wrote:
> > 
> > <snip>
> > 
> > You sent a cleanup patch in the middle of the merge window, when we
> > can't take any patches at the moment due to other work, and expect a
> > review in less than 24 hours?
> > 
> 
> No, he sent the patch one month ago, so to be honest he's quite patient,
> though he picked a wrong time to ping you. ;)

Obviously, I don't even know what month this is :)

Chen, very sorry about that.  I'll look into it next week, it's probably
lost somewhere in my todo queue.

greg k-h

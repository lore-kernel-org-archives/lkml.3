Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757858Ab3BBP5R (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:57:17 -0500
Received: from shutemov.name ([204.155.152.216]:37762 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757185Ab3BBP5O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:57:14 -0500
Date: Sat, 2 Feb 2013 17:58:58 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Cgroups <cgroups@vger.kernel.org>,
        Davide Libenzi <davidel@xmailserver.org>,
        Aaron Durbin <adurbin@google.com>, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH 1/4] eventfd: introduce eventfd_signal_hangup()
Message-ID: <20130202155858.GA13022@shutemov.name>
References: <510CB733.2080904@huawei.com>
 <510CB744.7000300@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <510CB744.7000300@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 02:50:44PM +0800, Li Zefan wrote:
> When an eventfd is closed, a wakeup with POLLHUP will be issued,
> but cgroup wants to issue wakeup explicitly, so when a cgroup is
> removed userspace can be notified.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>

Acked-by: Kirill A. Shutemov <kirill@shutemov.name>

-- 
 Kirill A. Shutemov

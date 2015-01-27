Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932329AbbA0QNW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 11:13:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932226AbbA0QNU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 11:13:20 -0500
From: Paul Moore <pmoore@redhat.com>
To: Huang Ying <ying.huang@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, LKP ML <lkp@01.org>
Subject: Re: [LKP] [fs] swapper/0: page allocation failure: order:0, mode:0x50
Date: Tue, 27 Jan 2015 11:13:16 -0500
Message-ID: <3589184.gcKqz6adq7@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <1422341985.24875.42.camel@intel.com>
References: <1422341985.24875.42.camel@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 27, 2015 02:59:45 PM Huang Ying wrote:
> FYI, we noticed the below changes on
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git master
> commit 6aaca9bab6116a2b392e7a07b5ff209741bc248f ("fs: create proper filename
> objects using getname_kernel()")
> 
> There are new kernel message as follow, that may have relationship with your
> patch.
> 
> [    4.798286] uvesafb: failed to execute /sbin/v86d
> [    4.799010] uvesafb: make sure that the v86d helper is installed and
> executable

Why are you applying this patch to 3.16?  It is currently in vfs#for-next and 
not marked for -stable?

Do you see the same problem when you test linux-next?  Although you may want 
to wait for today's linux-next release.

-- 
paul moore
security @ redhat


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672AbbAVWFz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:05:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbbAVWFy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:05:54 -0500
From: Paul Moore <pmoore@redhat.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-fsdevel@vger.kernel.org,
        linux-audit@redhat.com, rgb@redhat.com, sd@queasysnail.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/5] Overhaul the audit filename handling
Date: Thu, 22 Jan 2015 17:05:47 -0500
Message-ID: <1533670.bBthVOZCFd@sifl>
Organization: Red Hat
User-Agent: KMail/4.14.3 (Linux/3.16.7-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20150122214000.GX29656@ZenIV.linux.org.uk>
References: <20150122045303.1347.98054.stgit@localhost> <20150122212902.GW29656@ZenIV.linux.org.uk> <20150122214000.GX29656@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 22, 2015 09:40:01 PM Al Viro wrote:
> On Thu, Jan 22, 2015 at 09:29:03PM +0000, Al Viro wrote:
> > On Thu, Jan 22, 2015 at 04:25:13PM -0500, Paul Moore wrote:
> > > Your experimental branch looks good to me, thanks.
> > 
> > Pushed into for-next; I'm probably going to move that stuff into a
> > never-rebased branch, merged into for-next and safe to pull into your
> > tree if you want to do something on top of that set.
> 
> OK, vfs.git#getname is it; it's in never-to-be-rebased mode and it's merged
> into vfs.git#for-next (as of right now; HEAD is 9ee4c4).  If you need to do
> something on top of that stuff, pulling vfs.git#getname is safe.

Great, thanks.

-- 
paul moore
security @ redhat


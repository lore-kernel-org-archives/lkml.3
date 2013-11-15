Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3KOFqI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 00:46:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57961 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3KOFpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 00:45:54 -0500
Date: Fri, 15 Nov 2013 13:01:32 +0900
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peng Tao <bergwolf@gmail.com>
Cc: Cheng Shao <cheng_shao@xyratex.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Farrell <paf@cray.com>,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH 12/40] staging/lustre/nfs: writing to new files will
 return ENOENT
Message-ID: <20131115040132.GA11074@kroah.com>
References: <1384445622-12346-1-git-send-email-bergwolf@gmail.com>
 <1384445622-12346-13-git-send-email-bergwolf@gmail.com>
 <048D09EB-A44F-422F-A88C-D26E93C9225C@xyratex.com>
 <CA+a=Yy68yMFStD7Fufq-s0F8FqBOwU=1rsVKw43CUiu73u86vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+a=Yy68yMFStD7Fufq-s0F8FqBOwU=1rsVKw43CUiu73u86vg@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 12:28:20AM +0800, Peng Tao wrote:
> On Fri, Nov 15, 2013 at 12:22 AM, Cheng Shao <cheng_shao@xyratex.com> wrote:
> > Hi Peng,
> >
> > This patch was eventually reverted as it was causing interoperability issues with 2.1 Lustre server. We are working on the new patch, so please don't include this one.
> >
> Thanks for the notification. I didn't see the reverting patch in next
> 200 patches in Lustre tree so it must have happened recently.
> 
> Greg, please drop this one. I verified that the rest of the patchset
> can be applied cleanly.

Now dropped, thanks.

greg k-h

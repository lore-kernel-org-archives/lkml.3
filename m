Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611AbaEDCdg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 22:33:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59526 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753583AbaEDCdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 22:33:35 -0400
Date: Sat, 3 May 2014 22:33:31 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Andreas Dilger <andreas.dilger@intel.com>
Subject: Re: [PATCH] staging/lustre: Replace jobid acquiring with per node
 setting
Message-ID: <20140504023331.GB30871@kroah.com>
References: <1398651712-5015-1-git-send-email-green@linuxhacker.ru>
 <20140503232945.GA15714@kroah.com>
 <AD08F6C5-1BAD-455B-9A09-1FFB8D2CA42E@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AD08F6C5-1BAD-455B-9A09-1FFB8D2CA42E@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 03, 2014 at 09:20:06PM -0400, Oleg Drokin wrote:
> 
> On May 3, 2014, at 7:29 PM, Greg Kroah-Hartman wrote:
> 
> > On Sun, Apr 27, 2014 at 10:21:52PM -0400, Oleg Drokin wrote:
> >> Insted of meddling directly in process environment variables
> >> (which is also not possible on certain platforms due to not exported
> >> symbols), create jobid_name proc file to represent this info
> >> (to be filled by job scheduler epilogue).
> > That looks better, but what are you going to do about getting rid of all
> > of these proc files?  Just move them all at once?  I really don't like
> > the idea of adding new ones, and want a plan for what you all are going
> > to do here moving forward.
> 
> What proc files are to referring to, if I may ask?

All of them :)

> I don't think I saw complaints about proc files, the complaints I saw were mostly about
> reading env variables directly and the like so that was the focus of this patch.
> Did I miss some side discussion? Any pointers?

No, no side discussion, the proc files need to be removed / fixed before
the code can be merged to the "proper" part of the kernel tree.

thanks,

greg k-h

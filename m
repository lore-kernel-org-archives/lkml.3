Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab3KVTpO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 14:45:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56230 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755657Ab3KVTpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 14:45:07 -0500
Date: Fri, 22 Nov 2013 11:45:06 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Michael Marineau <michael.marineau@coreos.com>,
        Waiman Long <Waiman.Long@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: 3.12 Regression: dcache: Translating dentry into pathname
 without taking rename_lock 232d2d60
Message-ID: <20131122194506.GA25105@kroah.com>
References: <CAGr1u3vZU_Pxwu1nSab0PExNPQsE0xiSpcoMbUQ7MeGbJzBAjA@mail.gmail.com>
 <20131113123947.GB13318@ZenIV.linux.org.uk>
 <CAGr1u3spS2G8r7jCAnFZukE_zGkEGtsk0SSyTj3H39kK9E0_tQ@mail.gmail.com>
 <20131121230107.GA15179@kroah.com>
 <20131121232242.GJ10323@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131121232242.GJ10323@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 21, 2013 at 11:22:42PM +0000, Al Viro wrote:
> On Thu, Nov 21, 2013 at 03:01:07PM -0800, Greg KH wrote:
> 
> > Al, did this fix end up in Linus's tree yet?  I'd like to pull it into
> > the next 3.12-stable release, but will wait until Linus has it of
> > course.
> 
> Yes - ede4ce.

Thanks, now queued up.

greg k-h

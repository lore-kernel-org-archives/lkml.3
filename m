Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3DLUMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 16:12:53 -0400
Received: from mail-da0-f48.google.com ([209.85.210.48]:35812 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab3DLUMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 16:12:52 -0400
Date: Fri, 12 Apr 2013 13:12:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/26] Eliminate create_proc_read_entry() [RFC]
Message-ID: <20130412201232.GA22311@kroah.com>
References: <20130411190728.GC32045@kroah.com>
 <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
 <19749.1365719661@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19749.1365719661@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 11:34:21PM +0100, David Howells wrote:
> Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> > The ones I've been cc:ed on, with the exception of the hostap patch, I
> > will be glad to take though my trees now, unless you want to take them
> > yourself?
> 
> If Al is happy with it, he might want to take it through his tree since it's
> sat on top of his experimental branch - especially since the last patch is
> dependent on all the intermediate steps.

Ok, that's fine with me as well.

greg k-h

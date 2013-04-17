Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab3DQBC3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:02:29 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:59767 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab3DQBC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:02:27 -0400
Date: Tue, 16 Apr 2013 18:02:13 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: David Howells <dhowells@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        devel@driverdev.osuosl.org, Tommi Rantala <tt.rantala@gmail.com>,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 21/28] dgrp: Clean up the use of procfs [RFC]
Message-ID: <20130417010213.GG11541@kroah.com>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182713.27773.66239.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130416182713.27773.66239.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 07:27:13PM +0100, David Howells wrote:
> Clean up the use of procfs by the dgrp driver:
> 
>  (1) Use remove_proc_subtree() for the mass slaughter of a subdir full of proc
>      files rather than doing it manually.
> 
>  (2) When creating files, only call ID_TO_CHAR() once to generate the name.
> 
> Signed-off-by : David Howells <dhowells@redhat.com>
> cc: Bill Pemberton <wfp5p@virginia.edu>
> cc: Tommi Rantala <tt.rantala@gmail.com>
> cc: devel@driverdev.osuosl.org

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

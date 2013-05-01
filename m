Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572Ab3EASVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 14:21:47 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:38111 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201Ab3EASVl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 14:21:41 -0400
Date: Wed, 1 May 2013 11:21:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: SamuelOrtiz@kroah.com, Tomas Winkler <tomas.winkler@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: mei file2alias compile error
Message-ID: <20130501182138.GA17550@kroah.com>
References: <51814943.7000604@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51814943.7000604@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 09:56:35AM -0700, Dave Hansen wrote:
> Linus's current git isn't compiling for me:
> 
> >   HOSTCC  scripts/mod/file2alias.o
> > /home/davehans/linux.git/scripts/mod/file2alias.c: In function ‘do_mei_entry’:
> > /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: error: ‘OFF_mei_cl_device_id_name’ undeclared (first use in this function)
> > /home/davehans/linux.git/scripts/mod/file2alias.c:1140:1: note: each undeclared identifier is reported only once for each function it appears in
> > /home/davehans/linux.git/scripts/mod/file2alias.c: At top level:
> > /home/davehans/linux.git/scripts/mod/file2alias.c:1146:1: error: ‘SIZE_mei_cl_device_id’ undeclared here (not in a function)
> 
> I confirmed that this commit: e5354107e is the one causing it for me.
> My .config is here:
> 
> 	http://sr71.net/~dave/linux/config-3.9-meibad
> 
> Note that I don't even have CONFIG_INTEL_MEI enabled with this config.

I don't have CONFIG_INTEL_MEI set either, and I can't duplicate this.
Samuel and Tomas, can you please track this down?

thanks,

greg k-h

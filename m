Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaLTU1I (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 15:27:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:50302 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLTU1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 15:27:04 -0500
Date: Sat, 20 Dec 2014 12:27:02 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: sbaugh <sbaugh@andrew.cmu.edu>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        "moderated list:STAGING - LUSTRE..." <HPDD-discuss@ml01.01.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lustre: ptlrpc: add "ptlrpc_internal.h" to sec_gc.c
Message-ID: <20141220202702.GA1078@kroah.com>
References: <1419107253-27647-1-git-send-email-sbaugh@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419107253-27647-1-git-send-email-sbaugh@andrew.cmu.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 20, 2014 at 03:27:31PM -0500, sbaugh wrote:
> ptlrpc_internal.h contains the prototypes for sptlrpc_gc_init() and
> sptlrpc_gc_fini(), which are defined in sec_gc.c.
> 
> This removes the following sparse warnings:
> 
> drivers/staging/lustre/lustre/ptlrpc/sec_gc.c:217:5: warning: symbol 'sptlrpc_gc_init' was not declared. Should it be static?
> drivers/staging/lustre/lustre/ptlrpc/sec_gc.c:241:6: warning: symbol 'sptlrpc_gc_fini' was not declared. Should it be static?
> 
> Signed-off-by: sbaugh <sbaugh@andrew.cmu.edu>

I'm guessing this is not the name you use to sign a legal document,
right?  Please fix that up and resend.

thanks,

greg k-h

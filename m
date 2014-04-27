Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754524AbaD0RTw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:19:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaD0RTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:19:48 -0400
Date: Sun, 27 Apr 2014 10:20:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Oleg Drokin <oleg.drokin@intel.com>, Andrew Korty <ajk@iu.edu>
Subject: Re: [PATCH 04/47] staging/lustre/gss: Shared key mechanism & flavors
Message-ID: <20140427172032.GA961@kroah.com>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-5-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-5-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:28PM -0400, Oleg Drokin wrote:
> From: Andrew Korty <ajk@iu.edu>
> 
> Implement security flavors and GSSAPI mechanism to perform shared key
> authentication (ski) and encryption (skpi).
> 
> Signed-off-by: Andrew Korty <ajk@iu.edu>
> Reviewed-on: http://review.whamcloud.com/8629
> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3289
> Reviewed-by: Andreas Dilger <andreas.dilger@intel.com>
> Reviewed-by: Ken Hornstein <kenh@cmf.nrl.navy.mil>
> Signed-off-by: Oleg Drokin <oleg.drokin@intel.com>

Why are you adding new features to the code?

I really want the code cleaned up properly first, before anything new
can be added to it.  Otherwise it's just a loosing battle of cleanups
needed for the stuff you keep adding.

thanks,

greg k-h

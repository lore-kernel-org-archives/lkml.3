Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaD0RYq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 13:24:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35281 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbaD0RYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 13:24:44 -0400
Date: Sun, 27 Apr 2014 10:25:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Oleg Drokin <green@linuxhacker.ru>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Dmitry Eremin <dmitry.eremin@intel.com>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH 29/47] staging/lustre/lnet: lnet: fix issues found by
 Klocwork Insight tool
Message-ID: <20140427172528.GA7081@kroah.com>
References: <1398618431-29757-1-git-send-email-green@linuxhacker.ru>
 <1398618431-29757-30-git-send-email-green@linuxhacker.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398618431-29757-30-git-send-email-green@linuxhacker.ru>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 01:06:53PM -0400, Oleg Drokin wrote:
> From: Dmitry Eremin <dmitry.eremin@intel.com>
> 
> Null pointer 'cp' that comes from line 2544 may be dereferenced
> at line 2618.
> 
> Pointer 'ni' checked for NULL at line 1569 may be passed to
> function and may be dereferenced there by passing argument 1 to
> function 'lnet_ni_notify_locked' at line 1621.
> 
> Null pointer 'best_iface' that comes from line 802 may be
> dereferenced at line 832.
> 
> Buffer overflow of string buffer due to non null terminated string.
> 
> Pointer 'tsc' returned from call to function 'sfw_find_test_case'
> at line 571 may be NULL and will be dereferenced at line 572.
> 
> Local variable 'hash' is never used.

Each kernel patch should only do one thing, not 6 different things.
Please break this up into 6 different patches.

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaJJFgJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 01:36:09 -0400
Received: from 1wt.eu ([62.212.114.60]:17074 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750788AbaJJFgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 01:36:07 -0400
X-Greylist: delayed 313 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Oct 2014 01:36:06 EDT
Date: Fri, 10 Oct 2014 07:30:48 +0200
From: Willy Tarreau <w@1wt.eu>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable length encoding.
Message-ID: <20141010053048.GD3594@1wt.eu>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com> <1412888588-26755-164-git-send-email-kamal@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412888588-26755-164-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamal,

[ removed Don Bailey from the CC who's certainly not interested in this ]

On Thu, Oct 09, 2014 at 02:03:08PM -0700, Kamal Mostafa wrote:
> 3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Willy Tarreau <w@1wt.eu>
> 
> commit 72cf90124e87d975d0b2114d930808c58b4c05e4 upstream.

(...)

This one (and the accompanying revert) are still not present in more
recent stable kernels, so I find it surprizing that you're proposing
to integrate them now. If someone upgrades from 3.13.11.9 to 3.14.21
or 3.16.5, they'd expect to keep all fixes but will lose this one, so
this is a bit confusing. Is there any reason you're not tracking fixes
from more recent versions like Jiri, Li, Ben and I are doing ?

Thanks,
Willy


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161224AbaDJU30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 16:29:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48684 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758550AbaDJU3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 16:29:25 -0400
Date: Thu, 10 Apr 2014 13:31:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
Cc: *S-Par-Maintainer <SParMaintainer@unisys.com>, Ken Cox <jkc@redhat.com>,
        driver devel <devel@driverdev.osuosl.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] staging: unisys: fix copyright notices
Message-ID: <20140410203158.GA28612@kroah.com>
References: <C97001BC43954D438ACB059713BA5CDF92040F0F0D@USEA-EXCH7.na.uis.unisys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C97001BC43954D438ACB059713BA5CDF92040F0F0D@USEA-EXCH7.na.uis.unisys.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 10:08:52AM -0500, Romer, Benjamin M wrote:
> This patch replaces the inconsistent copyright symbols in each source
> file with (C).
> 
> Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
> ---

This patch is in base64, which ok, I can handle, as git can deal with
that.  But then it totally fails to apply to Linus's latest tree at all.

Can you please take a look at this, and resend it after fixing up
whatever needs to be fixed on your end?

thanks,

greg k-h

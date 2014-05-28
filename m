Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754392AbaE1XdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 19:33:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44114 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbaE1XdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 19:33:11 -0400
Date: Wed, 28 May 2014 16:36:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chaitanya Hazarey <c@24.io>
Cc: burzalodowa@gmail.com, andrea.merello@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Staging: rtl8192u: r8192U_wx.c Various Code cleanups
 and code-style additions
Message-ID: <20140528233647.GB3580@kroah.com>
References: <1401319428-20798-1-git-send-email-c@24.io>
 <1401319428-20798-2-git-send-email-c@24.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401319428-20798-2-git-send-email-c@24.io>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 28, 2014 at 04:23:48PM -0700, Chaitanya Hazarey wrote:
> Removed dead code
> Deleted stray newlines
> Added newlines for better code readability

These should all be broken up into individual patches.

Remember, each patch should just do _one_ thing.

thanks,

greg k-h

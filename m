Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932135Ab3ITUbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Sep 2013 16:31:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932121Ab3ITUbp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Sep 2013 16:31:45 -0400
Date: Fri, 20 Sep 2013 13:32:22 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: Drivers: scsi: FLUSH timeout
Message-ID: <20130920203222.GA14306@kroah.com>
References: <1379705547-15028-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379705547-15028-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 20, 2013 at 12:32:27PM -0700, K. Y. Srinivasan wrote:
> The SD_FLUSH_TIMEOUT value is currently hardcoded.

Hardcoded where?  Please, more context.

> On our cloud, we sometimes hit this timeout. I was wondering if we
> could make this a module parameter. If this is acceptable, I can send
> you a patch for this.

A module parameter don't make sense for a per-device value, does it?

greg k-h

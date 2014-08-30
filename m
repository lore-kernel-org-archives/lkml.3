Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950AbaH3TC5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 15:02:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3TC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 15:02:56 -0400
Date: Sat, 30 Aug 2014 12:02:56 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Spencer Baugh <sbaugh@andrew.cmu.edu>
Cc: "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        Niu Yawei <yawei.niu@intel.com>,
        Hongchao Zhang <hongchao.zhang@intel.com>,
        Alex Zhuravlev <alexey.zhuravlev@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        Oleg Drokin <oleg.drokin@intel.com>
Subject: Re: [PATCH] staging: fix style in lustre_import.h
Message-ID: <20140830190256.GA984@kroah.com>
References: <1408751862-31454-1-git-send-email-sbaugh@andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408751862-31454-1-git-send-email-sbaugh@andrew.cmu.edu>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 07:57:40PM -0400, Spencer Baugh wrote:
> This patch fixes style errors and warnings reported by
> scripts/checkpatch.pl

Which errors and warnings does it fix?

Please always be specific.

And only do one type of "fix" per patch, you do a few different ones
here, right?

Can you redo it and resend please?

thanks,

greg k-h

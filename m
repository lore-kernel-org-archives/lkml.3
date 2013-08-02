Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab3HBW16 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:27:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46268 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754204Ab3HBW15 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:27:57 -0400
Date: Sat, 3 Aug 2013 06:29:09 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC v01 0/3] Power Capping Framework
Message-ID: <20130802222909.GA28831@kroah.com>
References: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375466932-11842-1-git-send-email-srinivas.pandruvada@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:08:49AM -0700, Srinivas Pandruvada wrote:
> - A uniform sys-fs interface for all devices which can offer power capping

There is no "-" in sysfs please.

> - A common API for drivers, which will avoid code duplication and easy
> implementation of client drivers.
> 
> Once this framework is approved, we will submit a RAPL client driver using this
> framework.

No, you need users of a framework in order for it to be approved, we
don't add infrastructure without users.

Especially as what usually happens is, when you add actual users, the
framework changes to fix the bugs found in it :)

Ideally you will have more than one client driver submitted, as a
"framework" for just one driver seems a bit odd, don't you think?

Also, you add lots of new sysfs files, those need to be documented in
Documentation/ABI/ with this series.

thanks,

greg k-h

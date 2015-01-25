Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378AbbAYQP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 11:15:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54844 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbbAYQPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 11:15:50 -0500
Date: Sun, 25 Jan 2015 20:44:29 +0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Sudeep Dutt <sudeep.dutt@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Dave Jiang <dave.jiang@intel.com>, Nikhil Rao <nikhil.rao@intel.com>,
        Ashutosh Dixit <ashutosh.dixit@intel.com>
Subject: Re: [PATCH char-misc-next v2 00/13] misc: mic: SCIF driver
Message-ID: <20150125124429.GC21763@kroah.com>
References: <cover.1421097390.git.sudeep.dutt@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1421097390.git.sudeep.dutt@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:09:54PM -0800, Sudeep Dutt wrote:
> ChangeLog:
> =========
> v1 => v2:
> a) Use kernel-doc formatting for SCIF header file documentation, enhance
>    SCIF ring buffer documentation and formatting cleanup in patch 4 as
>    per feedback from Greg Kroah-Hartman
> b) SCIF bug fixes and cleanups since initial post
> 
> v1: Initial post @ https://lkml.org/lkml/2014/12/10/546

Do you have any test code that can be added to the tree to exercise this
api and at least give a hint as to how it all works from the userspace
side?  You don't have any pointers to any userspace code, what is using
this API?

thanks,

greg k-h

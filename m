Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752128AbaC3QYk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 12:24:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37177 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbaC3QYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 12:24:39 -0400
Date: Sun, 30 Mar 2014 09:26:41 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH driver-core-next] sysfs: restore in-kernel mount of sysfs
Message-ID: <20140330162641.GA5539@kroah.com>
References: <20140330123036.GA8942@htj.dyndns.org>
 <20140330131309.GE8942@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330131309.GE8942@htj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 09:13:09AM -0400, Tejun Heo wrote:
> Oops, this is not for driver-core-next but driver-core-linus.

It's _really_ late in the release cycle for something like this, can I
add it to 3.15-rc1 and if people are seeing issues, backport it to
3.14-stable?

thanks,

greg k-h

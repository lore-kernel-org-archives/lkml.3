Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933227AbaHYRBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 13:01:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59707 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526AbaHYRBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 13:01:14 -0400
Date: Mon, 25 Aug 2014 10:00:33 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kamal Mostafa <kamal@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Subject: Re: [3.8.y.z extended stable] Linux 3.8.13.28 stable review
Message-ID: <20140825170033.GA18021@kroah.com>
References: <1408985699-31838-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408985699-31838-1-git-send-email-kamal@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 25, 2014 at 09:54:46AM -0700, Kamal Mostafa wrote:
> This is the start of the review cycle for the Linux 3.8.13.28 stable kernel.
> 
>  ** NOTE: This will be the last Linux 3.8.y.z extended stable version
>  ** to be released and supported by me and the Ubuntu Kernel team.

I know this is the last release, but I have gotten some complaints by
people who are confused by the numbering scheme you are using for the
Canonical stable kernel releases.  Can you please use the EXTRAVERSION
field with a "-something" tag in it to differenciate from the "normal"
kernel.org stable releases?

A simple "-ubuntu" or "-canonical" or "-fuzzy_bunnies" marking would be
fine, or whatever you want to pick.

Everyone used to do this a long time ago when we had lots of different
kernel releases / trees floating around in the pre-git days, which made
things much easier to figure out where the trees came from.

thanks,

greg k-h

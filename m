Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaC3WEi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 18:04:38 -0400
Received: from mail-qg0-f47.google.com ([209.85.192.47]:60029 "EHLO
	mail-qg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751897AbaC3WEg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 18:04:36 -0400
Date: Sun, 30 Mar 2014 18:04:33 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Alexandre Demers <alexandre.f.demers@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH driver-core-next] sysfs: restore in-kernel mount of sysfs
Message-ID: <20140330220433.GA16771@htj.dyndns.org>
References: <20140330123036.GA8942@htj.dyndns.org>
 <20140330131309.GE8942@htj.dyndns.org>
 <20140330162641.GA5539@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330162641.GA5539@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 09:26:41AM -0700, Greg Kroah-Hartman wrote:
> On Sun, Mar 30, 2014 at 09:13:09AM -0400, Tejun Heo wrote:
> > Oops, this is not for driver-core-next but driver-core-linus.
> 
> It's _really_ late in the release cycle for something like this, can I
> add it to 3.15-rc1 and if people are seeing issues, backport it to
> 3.14-stable?

Sure, the problem doesn't seem to be too widespread anyways.
-stable'ing through rc1 should be fine.

Thanks.

-- 
tejun

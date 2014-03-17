Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaCQUNw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 16:13:52 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:59730 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900AbaCQUNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 16:13:51 -0400
Date: Mon, 17 Mar 2014 16:13:46 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexandre Demers <alexandre.f.demers@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to
 kern_mount() sysfs from sysfs_init()" prevents system from booting correctly
Message-ID: <20140317201346.GE17373@mtj.dyndns.org>
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com>
 <20140314140804.GG12613@htj.dyndns.org>
 <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Mar 14, 2014 at 11:48:10AM -0400, Alexandre Demers wrote:
> Since it takes a while before the system begins to display errors,
> I'll have to test it and report it later today when I'll get back from
> work.

Any update?

> Now, about the userland part, this seems a broad question... I'm using
> Arch Linux 64bit (updated mostly on a daily basis). But I suspect you
> are expecting a narrower information. Is there anything in particular
> you want to know?

I was just wondering whether you were running something really exotic.
Doesn't seem that way.  Weird that other people aren't hitting this
issue.  Hmm...

Thanks.

-- 
tejun

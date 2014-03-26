Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbaCZNSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:18:18 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:37986 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545AbaCZNSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:18:05 -0400
Date: Wed, 26 Mar 2014 09:18:00 -0400
From: Tejun Heo <tj@kernel.org>
To: Alexandre Demers <alexandre.f.demers@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [Regression, bisected 9e30cc] "sysfs, kernfs: no need to
 kern_mount() sysfs from sysfs_init()" prevents system from booting correctly
Message-ID: <20140326131800.GA7171@htj.dyndns.org>
References: <CAPEhTTFP3N-ReasmgL5n82mve8p8M3crqmaMvzV+F2p5JCSRbQ@mail.gmail.com>
 <20140314140804.GG12613@htj.dyndns.org>
 <CAPEhTTG3kCDk2V9dbCB5mATKt2nyVj9iiv9g5MTOEbqYrpPefg@mail.gmail.com>
 <20140317201346.GE17373@mtj.dyndns.org>
 <5327AAA8.2080703@gmail.com>
 <53322777.3030703@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53322777.3030703@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 25, 2014 at 09:03:51PM -0400, Alexandre Demers wrote:
> So, I tried RC8 and I'm still getting the error. It start too fast
> to be able to read whatever it is saying, but here is what I can
> read:
> ...
> cp: error writing /run/initramfs/new_root/...
> cp: failed to extend ...
> ... (and so on)
> 
> It goes on like that for a long time.

Ooh, I thought you were gonna find out what filled up the filesystem
after rebooting into the older kernel.  Can you please do that?  Also,
pressing "ScrLk" should stop the screen from scrolling.

Thanks.

-- 
tejun

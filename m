Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbaGBOOW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 10:14:22 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:47558 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469AbaGBOOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 10:14:20 -0400
Date: Wed, 2 Jul 2014 10:14:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Josh Boyer <jwboyer@fedoraproject.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Brian Lane <bcl@redhat.com>, John McCutchan <john@johnmccutchan.com>,
        Robert Love <rlove@rlove.org>, Eric Paris <eparis@parisplace.org>
Subject: Re: [PATCH driver-core-linus] kernfs: kernfs_notify() must be
 useable from non-sleepable contexts
Message-ID: <20140702141416.GA23275@htj.dyndns.org>
References: <CA+5PVA4h2hQJLrAm4eEZ8oUgGiAjq2y5eAyBcJWxK_FiQXnuQg@mail.gmail.com>
 <20140629082637.GA23942@redhat.com>
 <20140629193222.GA7030@lst.de>
 <20140629204710.GB11100@redhat.com>
 <53B07D48.60003@kernel.dk>
 <20140630201741.GA20853@htj.dyndns.org>
 <20140701204103.GA12459@htj.dyndns.org>
 <20140701205148.GA26542@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140701205148.GA26542@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 01, 2014 at 01:51:48PM -0700, Greg Kroah-Hartman wrote:
> Looks good to me, do you want to take this with your other kernfs
> patches for 3.16-final?  Or if you don't have that, I can take it
> through my tree, it's your choice, either is fine for me.
> 
> If you want it in your tree, feel free to add:
> 	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

The other kernfs changes are cgroup specific and in
cgroup/for-3.16-fixes.  I think this one fits better in the driver
core tree.  Can you please route it?

Thanks!

-- 
tejun

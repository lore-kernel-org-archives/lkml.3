Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753103AbaJMF6S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:58:18 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:34947 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496AbaJMF6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:58:16 -0400
Date: Mon, 13 Oct 2014 13:58:10 +0800
From: WANG Chao <wangchao19890207@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Oleg Drokin <oleg.drokin@intel.com>,
        Andreas Dilger <andreas.dilger@intel.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Masaru Nomura <massa.nomura@gmail.com>, Peng Tao <bergwolf@gmail.com>,
        Chi Pham <fempsci@gmail.com>,
        Fredrick John Berchmans <fredrickprashanth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH resend] staging, lustre: fix a sparse error
Message-ID: <20141013055810.GB2013@dhcp-17-37.nay.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141012191702.GS7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/12/14 at 08:17pm, Al Viro wrote:
> On Fri, Oct 10, 2014 at 11:21:16AM +0800, WANG Chao wrote:
> 
> > I think __user annotation is for no dereferencing in kernel space. In
> > this case, I think it's fine to override this error by __force. Because
> > they're pointers with identical target types.
> 
> Umm...  The real question seems to be whether iovec is the right type in
> the first place.  Does ->tx_iov ever contain a vector with _userland_
> pointers?  If not, it ought to be struct kvec * instead.

I'm afraid I'm not familiar with lustre.

[CCing lustre maintainers]

Oleg and Andreas:

Could you answer the Al's question?

For your information, my original post was here:
https://lkml.org/lkml/2014/10/9/135

Thanks
WANG Chao

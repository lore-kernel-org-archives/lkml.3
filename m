Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409AbaIIKse (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 06:48:34 -0400
Received: from gofer.mess.org ([80.229.237.210]:51745 "EHLO gofer.mess.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaIIKsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 06:48:33 -0400
X-Greylist: delayed 564 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Sep 2014 06:48:32 EDT
Date: Tue, 9 Sep 2014 11:39:04 +0100
From: Sean Young <sean@mess.org>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: Re: [PATCH] [media] mceusb: fix usbdev leak
Message-ID: <20140909103903.GA623@gofer.mess.org>
References: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410214243-6319-1-git-send-email-khoroshilov@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 09, 2014 at 02:10:43AM +0400, Alexey Khoroshilov wrote:
> mceusb_init_rc_dev() does usb_get_dev(), but there is no any
> usb_put_dev() in the driver.

drivers/media/rc/imon.c suffers from the same problem.

Thanks
Sean

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab3GLXOK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 19:14:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754563Ab3GLXOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 19:14:07 -0400
Date: Fri, 12 Jul 2013 16:14:02 -0700 (PDT)
Message-Id: <20130712.161402.460159983188127882.davem@redhat.com>
To: hayeswang@realtek.com
Cc: gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH net 2/2] usb/net/r815x: fix cast to restricted __le32
From: David Miller <davem@redhat.com>
In-Reply-To: <1373617576-2272-2-git-send-email-hayeswang@realtek.com>
References: <1373617576-2272-1-git-send-email-hayeswang@realtek.com>
	<1373617576-2272-2-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Fri, 12 Jul 2013 16:26:16 +0800

>>> drivers/net/usb/r815x.c:38:16: sparse: cast to restricted __le32
>>> drivers/net/usb/r815x.c:67:15: sparse: cast to restricted __le32
>>> drivers/net/usb/r815x.c:69:13: sparse: incorrect type in assignment (different base types)
>    drivers/net/usb/r815x.c:69:13:    expected unsigned int [unsigned] [addressable] [assigned] [usertype] tmp
>    drivers/net/usb/r815x.c:69:13:    got restricted __le32 [usertype] <noident>
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> Spotted-by: kbuild test robot <fengguang.wu@intel.com>

Applied.

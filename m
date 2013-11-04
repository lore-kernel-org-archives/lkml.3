Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753147Ab3KDJRr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:17:47 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37805 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752682Ab3KDJRq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:17:46 -0500
Message-ID: <1383556658.23830.2.camel@linux-fkkt.site>
Subject: Re: [PATCH V5 net-next 2/3] net: huawei_cdc_ncm: Introduce the
 huawei_cdc_ncm driver
From: Oliver Neukum <oneukum@suse.de>
To: =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc: Enrico Mioso <mrkiko.rs@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Steve Glendinning <steve.glendinning@shawell.net>,
        Robert de Vries <rhdv@xs4all.nl>, Hayes Wang <hayeswang@realtek.com>,
        Freddy Xin <freddy@asix.com.tw>,
        Liu Junliang <liujunliang_ljl@163.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:USB NETWORKING DR..." <linux-usb@vger.kernel.org>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        ModemManager-devel@lists.freedesktop.org
Date: Mon, 04 Nov 2013 10:17:38 +0100
In-Reply-To: <87fvrgwe0e.fsf@nemi.mork.no>
References: <1380516609-31242-1-git-send-email-mrkiko.rs@gmail.com>
	 <1380516609-31242-3-git-send-email-mrkiko.rs@gmail.com>
	 <1380532073.1484.15.camel@linux-fkkt.site> <87fvrgwe0e.fsf@nemi.mork.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-11-01 at 12:35 +0100, Bjørn Mork wrote:

> So I believe we should do the update unconditionally, and but skip
> usb_autopm_put_interface if the get failed.  Accordingly, these
> functions should always return 0 (not that there is anything currently
> checking the return anyway).
> 
> I'll prepare patches for cdc-wdm, qmi_wwan and cdc_mbim.

Good plan.

	Regards
		Oliver



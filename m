Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755187Ab3JVVDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 17:03:44 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:63114 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab3JVVDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 17:03:42 -0400
Date: Tue, 22 Oct 2013 14:03:38 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
Cc: Tony Lindgren <tony@atomide.com>, Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi, pavel@ucw.cz
Subject: Re: [PATCH 2/4] power: isp1704_charger: Fix driver to work with
 changes introduced in v3.5
Message-ID: <20131022210337.GA6148@teo>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <1378630239-10006-3-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1378630239-10006-3-git-send-email-pali.rohar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 08, 2013 at 10:50:37AM +0200, Pali Rohár wrote:
> * omap musb driver does not report USB_EVENT_ENUMERATED event anymore
> * omap musb driver reporting USB_EVENT_VBUS when charger is connected
> * read last event from phy->last_event (instead from ulpi register)
> * do not call wall charger detection more times
> 
> Signed-off-by: Pali Rohár <pali.rohar@gmail.com>

Applied, thanks a lot!

(Per others' review comments I am assuming that the second isp1704 patch
will be reworked to support device-tree, so I am not applying it.)

Thanks,

Anton

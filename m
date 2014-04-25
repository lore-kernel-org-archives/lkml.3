Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866AbaDYBvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 21:51:21 -0400
Received: from senator.holtmann.net ([87.106.208.187]:46951 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaDYBvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 21:51:17 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: pull request: bluetooth 2014-04-24
From: Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20140425014446.GC3410@tuxdriver.com>
Date: Thu, 24 Apr 2014 18:51:13 -0700
Cc: "Gustavo F. Padovan" <gustavo@padovan.org>,
        "linux-wireless@vger.kernel.org Wireless" 
	<linux-wireless@vger.kernel.org>,
        BlueZ development <linux-bluetooth@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <C9BCBE06-78C4-41C6-9B70-BFB2C6AFDF7A@holtmann.org>
References: <20140424145329.GD7832@joana> <20140425014446.GC3410@tuxdriver.com>
To: "John W. Linville" <linville@tuxdriver.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

> This tag has a lot of stuff in it not in the wireless tree.
> Please only send me pull requests that only include patches related
> to Bluetooth.
> 
>> Some fixes for 3.15. There is a revert for the intel driver, a new device id,
>> and two important SSP fixes from Johan.
>> Also we've noticed that your wireless.git tree is not up to date, so this pull
>> was rebased on top of net.git. If you pull from this you'll will be pulling
>> net/master from yesterday as well.

as Gustavo explained, this is against net.git since wireless.git has not yet been rebased.

Regards

Marcel


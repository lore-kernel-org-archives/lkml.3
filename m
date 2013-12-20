Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab3LTDj7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:39:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48757 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab3LTDj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:39:57 -0500
Date: Thu, 19 Dec 2013 19:40:04 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com
Subject: Re: [PATCH 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
Message-ID: <20131220034004.GA8160@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
 <20131220032217.GC32310@kroah.com>
 <CAN1v_PsibDTwQ9_ZxRnBtJA46BPne6fTuS_9TddWPZt6ewwgQQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAN1v_PsibDTwQ9_ZxRnBtJA46BPne6fTuS_9TddWPZt6ewwgQQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: No.
Q: Should I include quotations after my reply?

http://daringfireball.net/2007/07/on_top

On Thu, Dec 19, 2013 at 07:27:35PM -0800, Ravi Patel wrote:
> APM X-Gene SoC Ethernet driver is planned to be submitted on Dec 20 2013.
> Ethernet driver will be using these exported API's from QMTM driver.

Please submit a user of the api as part of the series, otherwise we
can't evaluate if it's really the correct thing to do or not.

> The APM X-Gene SoC Ethernet driver is going to live in drivers/net/ethernet/apm
> /xgene.

So this is a "bus"?  How is the ethernet device going to show up in
sysfs as a parent of what as this isn't part of the driver model?

greg k-h

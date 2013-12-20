Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754110Ab3LTEYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 23:24:21 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49011 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab3LTEYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 23:24:19 -0500
Date: Thu, 19 Dec 2013 20:24:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH 2/4] misc: xgene: Add base driver for APM X-Gene SoC
 Queue Manager/Traffic Manager
Message-ID: <20131220042426.GA21726@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
 <1387507503-7565-3-git-send-email-rapatel@apm.com>
 <20131220032133.GB32310@kroah.com>
 <CAN1v_PuBZHN85xTodfSZ-+H4Wdj0T8kSFUJB56KVj9xFH3--JQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1v_PuBZHN85xTodfSZ-+H4Wdj0T8kSFUJB56KVj9xFH3--JQ@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A: Top-posting.
Q: What is the most annoying thing in e-mail?

http://daringfireball.net/2007/07/on_top

On Thu, Dec 19, 2013 at 07:41:13PM -0800, Ravi Patel wrote:
> There is no need to talk to this driver from userspace.
> It is a device which is used by other IO devices to communicate with each
> other, including CPU.
> For example, if CPU (software) wants to send a message to Ethernet HW (i.e.
> send packet),
> it used this driver to enqueue a message to Ethernet.
> In other direction, if Ethernet HW receives a packet, it uses QM/TM device to
> send message to
> CPU (software) to process packet.

So it's a "bus" type of thing, right?

My question of "why isn't this reflected in the driver model" still
stands.

thanks,

greg k-h

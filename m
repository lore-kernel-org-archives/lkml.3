Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347Ab3LTDV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:21:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48631 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab3LTDV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:21:26 -0500
Date: Thu, 19 Dec 2013 19:21:33 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: arnd@arndb.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH 2/4] misc: xgene: Add base driver for APM X-Gene SoC
 Queue Manager/Traffic Manager
Message-ID: <20131220032133.GB32310@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
 <1387507503-7565-3-git-send-email-rapatel@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387507503-7565-3-git-send-email-rapatel@apm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:45:01PM -0800, Ravi Patel wrote:
> This patch adds APM X-Gene SoC Queue Manager/Traffic Manager base driver.
>  QMTM is requried by Ethernet, PktDMA and Security Engine subsystems.

How does this driver talk to userspace?  Or is it just a "bus" for
devices to attach to and use to talk to the real devices in the system?
If so, why isn't it represented in the driver model?

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479Ab3LTDWN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 22:22:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48639 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030Ab3LTDWL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 22:22:11 -0500
Date: Thu, 19 Dec 2013 19:22:17 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Ravi Patel <rapatel@apm.com>
Cc: arnd@arndb.de, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com
Subject: Re: [PATCH 0/4] misc: xgene: Add support for APM X-Gene SoC Queue
 Manager/Traffic Manager
Message-ID: <20131220032217.GC32310@kroah.com>
References: <1387507503-7565-1-git-send-email-rapatel@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387507503-7565-1-git-send-email-rapatel@apm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:44:59PM -0800, Ravi Patel wrote:
> This patch adds support for APM X-Gene SoC Queue Manager/Traffic Manager.
>  QMTM is required by APM X-Gene SoC Ethernet, PktDMA and Security Engine
>  subsystems. All subsystems communicate with QMTM using messages which
>  include information about the work to be performed and the location of
>  associated data buffers.

And finally, where are the drivers that are going to use these apis you
are creating here?  Where are they going to live, and when are they
going to be submitted?

thanks,

greg k-h

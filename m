Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab3LUVLr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 16:11:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:32810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756047Ab3LUVLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 16:11:46 -0500
Date: Sat, 21 Dec 2013 13:11:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Iyappan Subramanian <isubramanian@apm.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        jcm@redhat.com, patches@apm.com, Ravi Patel <rapatel@apm.com>,
        Keyur Chudgar <kchudgar@apm.com>
Subject: Re: [PATCH 3/5] drivers: net: APM X-Gene SoC Ethernet base driver
Message-ID: <20131221211158.GB30102@kroah.com>
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com>
 <1387597376-29303-4-git-send-email-isubramanian@apm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387597376-29303-4-git-send-email-isubramanian@apm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 20, 2013 at 07:42:54PM -0800, Iyappan Subramanian wrote:
> Ethernet base device driver for APM X-Gene SoC.

Why is this a platform driver and not a bus driver for a xgene device?

thanks,

greg k-h

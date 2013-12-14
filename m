Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051Ab3LNT1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 14:27:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58655 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753854Ab3LNT1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 14:27:01 -0500
Date: Sat, 14 Dec 2013 09:25:45 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Levente Kurusa <levex@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        =?utf-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/4] net: phy: call put_device on device_register()
 failure
Message-ID: <20131214172545.GD22520@kroah.com>
References: <1386959996-7958-1-git-send-email-levex@linux.com>
 <1386959996-7958-2-git-send-email-levex@linux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386959996-7958-2-git-send-email-levex@linux.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 07:39:53PM +0100, Levente Kurusa wrote:
> It is required to call put_device() if device_register() fails,
> so that we give up the last reference to the device. Calling put_device
> allows for mdiobus_release to be executed, kfreeing the bus.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Signed-off-by: Levente Kurusa <levex@linux.com>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

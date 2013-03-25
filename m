Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933364Ab3CYUVu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 16:21:50 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49967 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933156Ab3CYUVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 16:21:48 -0400
Date: Mon, 25 Mar 2013 13:21:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next 2/2] mei: drop RECOVERING_FROM_RESET device state
Message-ID: <20130325202146.GA14900@kroah.com>
References: <1363513281-12606-1-git-send-email-tomas.winkler@intel.com>
 <1363513281-12606-2-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1363513281-12606-2-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 11:41:21AM +0200, Tomas Winkler wrote:
> ECOVERING_FROM_RESET device state is never set
> we can remove it

Really?  I now get the following build error with this patch applied:

drivers/misc/mei/pci-me.c: In function ‘mei_pci_suspend’:
drivers/misc/mei/pci-me.c:323:24: error: ‘MEI_DEV_RECOVERING_FROM_RESET’ undeclared (first use in this function)
drivers/misc/mei/pci-me.c:323:24: note: each undeclared identifier is reported only once for each function it appears in

Please be more careful.

greg k-h

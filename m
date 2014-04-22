Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756759AbaDVWCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 18:02:37 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:63587 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaDVWCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 18:02:35 -0400
Date: Tue, 22 Apr 2014 15:02:31 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: Re: [PATCH 0/2] net: Add Keystone NetCP ethernet driver support
Message-ID: <20140422150231.2e87b7eb@nehalam.linuxnetplumber.net>
In-Reply-To: <1398201675-17379-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398201675-17379-1-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2014 17:21:13 -0400
Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> NetCP driver has a plug-in module architecture where each of the NetCP
> sub-modules exist as a loadable kernel module which plug in to the netcp
> core. These sub-modules are represented as "netcp-devices" in the dts
> bindings. It is mandatory to have the ethernet switch sub-module for
> the ethernet interface to be operational. Any other sub-module like the
> PA is optional.

Where is the implementation of these modules. You need to include
this as separate patch set. Also the hooks for these modules should all
be EXPORT_SYMBOL_GPL() to disallow proprietary modules.

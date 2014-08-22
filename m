Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755795AbaHVCsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 22:48:47 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:61216 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbaHVCsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 22:48:45 -0400
Date: Thu, 21 Aug 2014 19:48:38 -0700
From: Stephen Hemminger <stephen@networkplumber.org>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <robh+dt@kernel.org>, <grant.likely@linaro.org>,
        <devicetree@vger.kernel.org>, <sandeep_n@ti.com>
Subject: Re: [PATCH v2 2/3] net: Add Keystone NetCP ethernet driver
Message-ID: <20140821194838.32f2c3f1@uryu.home.lan>
In-Reply-To: <1408115562-22487-3-git-send-email-santosh.shilimkar@ti.com>
References: <1408115562-22487-1-git-send-email-santosh.shilimkar@ti.com>
	<1408115562-22487-3-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Aug 2014 11:12:41 -0400
Santosh Shilimkar <santosh.shilimkar@ti.com> wrote:

> NetCP driver has a plug-in module architecture where each of the NetCP
> sub-modules exist as a loadable kernel module which plug in to the netcp
> core. These sub-modules are represented as "netcp-devices" in the dts
> bindings. It is mandatory to have the ethernet switch sub-module for
> the ethernet interface to be operational. Any other sub-module like the
> PA is optional.

What are you doing to prevent/discourage proprietary binary only
sub-modules?

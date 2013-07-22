Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab3GVI66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 04:58:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18678 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab3GVI64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 04:58:56 -0400
Date: Mon, 22 Jul 2013 17:58:52 +0900 (JST)
Message-Id: <20130722.175852.1830570446481516308.yamato@redhat.com>
To: fengguang.wu@intel.com
Cc: eduardo.valentin@ti.com, rui.zhang@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [thermal_init] kernel BUG at net/netlink/genetlink.c:145!
From: Masatake YAMATO <yamato@redhat.com>
In-Reply-To: <20130722083145.GB19067@localhost>
References: <20130722083145.GB19067@localhost>
Organization: Red Hat Japan, Inc.
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hi Eduardo,
> 
> I got the below dmesg and the first bad commit says that
> thermal_init() is trying to register a too long group name.

It may be related to my mistake.

    http://lists.openwall.net/netdev/2013/03/20/133
    http://lists.openwall.net/netdev/2013/03/21/79

Masatake YAMATO

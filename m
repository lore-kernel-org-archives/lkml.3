Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab3EUIvd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:51:33 -0400
Received: from mail-qe0-f46.google.com ([209.85.128.46]:40078 "EHLO
	mail-qe0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913Ab3EUIvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:51:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130521.013912.96249995742935192.davem@davemloft.net>
References: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
	<20130521.001444.1361294042663568537.davem@davemloft.net>
	<CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com>
	<20130521.013912.96249995742935192.davem@davemloft.net>
Date: Tue, 21 May 2013 11:43:23 +0300
Message-ID: <CAJZOPZJD5QpkmkJF9qpWV3Q28aioLw5CuT5X4URxDC4eSby3nQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: Or Gerlitz <or.gerlitz@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: eilong@broadcom.com, eliezer.tamir@linux.intel.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jesse.brandeburg@intel.com, donald.c.skidmore@intel.com,
        e1000-devel@lists.sourceforge.net, willemb@google.com,
        andi@firstfloor.org, hpa@zytor.com, eliezer@tamir.org.il
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 11:39 AM, David Miller <davem@davemloft.net> wrote:

> It's one of those "implementation details", I hate it too.

Maybe if we bake it on this list little further we can see how to get
away from that, or what's the most non ugly way for that?

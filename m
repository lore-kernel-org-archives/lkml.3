Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3EUIVh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:21:37 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:33774 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3EUIVf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:21:35 -0400
MIME-Version: 1.0
In-Reply-To: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	<20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
	<CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
	<519B1A2B.4010909@linux.intel.com>
	<1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
Date: Tue, 21 May 2013 11:21:34 +0300
Message-ID: <CAJZOPZKzTk+zJ2z0Bv9y1iZRdXb842z_WG8E3jNCoHw0C3fhQQ@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: Or Gerlitz <or.gerlitz@gmail.com>
To: eilong@broadcom.com
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 10:06 AM, Eilon Greenstein <eilong@broadcom.com> wrote:
> Or - at least for the bnx2x, it is easy to add support for this new ndo.

Do you understand what's the equivalent of that mysterious module
param for your driver/HW - or you just copied and pasted that black
magic code?

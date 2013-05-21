Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755974Ab3EUHG6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 03:06:58 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:2063 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754197Ab3EUHG5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 03:06:57 -0400
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
Message-ID: <1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
From: "Eilon Greenstein" <eilong@broadcom.com>
Reply-to: eilong@broadcom.com
To: "Eliezer Tamir" <eliezer.tamir@linux.intel.com>,
        "Or Gerlitz" <or.gerlitz@gmail.com>
cc: "Dave Miller" <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org,
        "Jesse Brandeburg" <jesse.brandeburg@intel.com>,
        "Don Skidmore" <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        "Willem de Bruijn" <willemb@google.com>,
        "Andi Kleen" <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        "Eliezer Tamir" <eliezer@tamir.org.il>
Date: Tue, 21 May 2013 10:06:43 +0300
In-Reply-To: <519B1A2B.4010909@linux.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
 <20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
 <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
 <519B1A2B.4010909@linux.intel.com>
Organization: Broadcom
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18)
MIME-Version: 1.0
X-WSS-ID: 7D85C3B831W23788522-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-21 at 09:54 +0300, Eliezer Tamir wrote:
> On 20/05/2013 23:20, Or Gerlitz wrote:
> > On Mon, May 20, 2013 at 1:16 PM, Eliezer Tamir
> > <eliezer.tamir@linux.intel.com> wrote:
> >> Add the ixgbe driver code implementing ndo_ll_poll.
> >> It should be easy for other drivers to do something similar
> >> in order to enable support for CONFIG_INET_LL_RX_POLL
> >
> > I am not sure,
> 
> Willem ported this to <some undisclosed HW that they use at Google>, his 
> feedback was that it was not a major effort.

We also played with applying a similar patch on the bnx2x and it looks
great :) - Thanks Eliezer!

Or - at least for the bnx2x, it is easy to add support for this new ndo.

Hopefully this series will be accepted so we can send follow up support
for the bnx2x as well.

Thanks,
Eilon




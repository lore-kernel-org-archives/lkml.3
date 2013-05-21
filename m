Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3EUIYo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 04:24:44 -0400
Received: from mail-qc0-f182.google.com ([209.85.216.182]:33030 "EHLO
	mail-qc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab3EUIYm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 04:24:42 -0400
MIME-Version: 1.0
In-Reply-To: <20130521.001444.1361294042663568537.davem@davemloft.net>
References: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
	<519B1A2B.4010909@linux.intel.com>
	<1369120003.25971.2.camel@lb-tlvb-eilong.il.broadcom.com>
	<20130521.001444.1361294042663568537.davem@davemloft.net>
Date: Tue, 21 May 2013 11:24:41 +0300
Message-ID: <CAJZOPZJTA9A8T4R8MtRCeqcYj3XJWFCXF+ojmEqza5TMj-6G+w@mail.gmail.com>
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

On Tue, May 21, 2013 at 10:14 AM, David Miller <davem@davemloft.net> wrote:
> From: "Eilon Greenstein" <eilong@broadcom.com>
> Date: Tue, 21 May 2013 10:06:43 +0300
>
>> Hopefully this series will be accepted so we can send follow up support
>> for the bnx2x as well.
>
> I think in two or three more iterations it will be merged.
>
> There are no objections on the fundamentals, it's just implementation
> details and coding style at this point.

Dave, sorry, I might be a bit behind the rest of the reviewers, but I
just fail to understand nor find any reference that explains the
module param of ixgbe nor it makes sense to me to merge that piece of
the code upstream (its not for staging, correct?), as I wrote here
http://marc.info/?l=linux-netdev&m=136908123432072&w=2 basically, I
know you're not a great fun of module params (to say the least) and
surely not something named  "allow_unsafe_removal", thoughts?

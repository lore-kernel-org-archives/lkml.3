Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab3KQWOJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 17:14:09 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51574 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3KQWOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 17:14:04 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH v5 2/3] of/selftest: Add self tests for manipulation of properties
To: Rob Herring <robherring2@gmail.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
In-Reply-To: <CAL_JsqK-ejMmc36OzSLi=odHkVPv_717b4sZyuJkj=UFVxsx0g@mail.gmail.com>
References: <1384537604-5032-1-git-send-email-grant.likely@linaro.org> < 1384537604-5032-3-git-send-email-grant.likely@linaro.org> < CAL_JsqK-ejMmc36OzSLi=odHkVPv_717b4sZyuJkj=UFVxsx0g@mail.gmail.com>
Date: Sun, 17 Nov 2013 22:13:59 +0000
Message-Id: <20131117221359.C39EAC406A5@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Nov 2013 13:09:13 -0600, Rob Herring <robherring2@gmail.com> wrote:
> On Fri, Nov 15, 2013 at 11:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> > Adds a few simple test cases to ensure that addition, update and removal
> > of device tree node properties works correctly.
> >
> > Signed-off-by: Grant Likely <grant.likely@linaro.org>
> > Cc: Rob Herring <rob.herring@calxeda.com>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: David S. Miller <davem@davemloft.net>
> > Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> > Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> > ---
> >  drivers/of/selftest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 62 insertions(+)
> 
> Does this need to depend on or select OF_DYNAMIC?

It shouldn't. The property manipulation does not depend on OF_DYNAMIC.
Only the node manipulation does. When I do more testing next week I'll
verify.

g.

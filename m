Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752984Ab3KPTJV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Nov 2013 14:09:21 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:49572 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3KPTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Nov 2013 14:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <1384537604-5032-3-git-send-email-grant.likely@linaro.org>
References: <1384537604-5032-1-git-send-email-grant.likely@linaro.org>
	<1384537604-5032-3-git-send-email-grant.likely@linaro.org>
Date: Sat, 16 Nov 2013 13:09:13 -0600
Message-ID: <CAL_JsqK-ejMmc36OzSLi=odHkVPv_717b4sZyuJkj=UFVxsx0g@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] of/selftest: Add self tests for manipulation of properties
From: Rob Herring <robherring2@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>,
        Nathan Fontenot <nfont@linux.vnet.ibm.com>,
        Pantelis Antoniou <panto@antoniou-consulting.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 11:46 AM, Grant Likely <grant.likely@linaro.org> wrote:
> Adds a few simple test cases to ensure that addition, update and removal
> of device tree node properties works correctly.
>
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>
> Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
> ---
>  drivers/of/selftest.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 62 insertions(+)

Does this need to depend on or select OF_DYNAMIC?

Rob

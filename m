Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751832AbaLRCjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 21:39:12 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:41013 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307AbaLRCjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 21:39:10 -0500
MIME-Version: 1.0
In-Reply-To: <54920597.6090305@ti.com>
References: <54907884.2040502@ti.com>
	<5491ACE6.4070108@ti.com>
	<CAErSpo4hwMPOYBDZTu_fgKaUDYZ4h+jVpz5EigpErOgo6xO8mQ@mail.gmail.com>
	<54920529.4080007@ti.com>
	<54920597.6090305@ti.com>
Date: Thu, 18 Dec 2014 10:39:08 +0800
X-Google-Sender-Auth: h9Tn8CSdEjWD1hhQLEKzR_hV2jg
Message-ID: <CANeU7Q=85c8ehgCitG-Ujrr5O78V1yq9o=abJ8pwBBs0JOWAEg@mail.gmail.com>
Subject: Re: How to fix CHECK warning: testing a 'safe expression' ?
From: Christopher Li <sparse@chrisli.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 6:37 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:
>         if (!ks_pcie) {
>                 dev_err(dev, "no memory for keystone pcie\n");
>                 return -ENOMEM;
>         }
>         pp = &ks_pcie->pp;
>
>         /* initialize SerDes Phy if present */
>         phy = devm_phy_get(dev, "pcie-phy");
> ===>    if (!IS_ERR_OR_NULL(phy)) {
>                 ret = phy_init(phy);
>                 if (ret < 0)
>                         return ret;
>

Hi,

Do you have a smaller stand alone test case which I can reproduce with sparse?

Thanks

Chris

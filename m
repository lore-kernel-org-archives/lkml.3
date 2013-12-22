Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3LVJg3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 04:36:29 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:63657 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753258Ab3LVJgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 04:36:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/5] drivers: net: Adding support for APM X-Gene SoC Ethernet base driver
Date: Sun, 22 Dec 2013 10:35:44 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Iyappan Subramanian <isubramanian@apm.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org,
        patches@apm.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jcm@redhat.com, Keyur Chudgar <kchudgar@apm.com>,
        Ravi Patel <rapatel@apm.com>
References: <1387597376-29303-1-git-send-email-isubramanian@apm.com>
In-Reply-To: <1387597376-29303-1-git-send-email-isubramanian@apm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201312221035.44961.arnd@arndb.de>
X-Provags-ID: V02:K0:LAu1bBGXvG4R+PFpTEtH5NRomE5MVrRbvxZ9JHKbFTR
 TToMXrhOPMd/IuydWTo5evAsYkwU9GVOuBGe9iDcgb8+DiGbRy
 4OupMUcPStqqC4u/Tso29zNA4ELEzAGIAh6yDcoT32p4z44qfP
 Z2VMZ8XtTeubydkDkD9MCw2ofCsibbbkZ1y9vmOciNvzEFfJuj
 gKuGk9UJCzvc9RAZYtCywbSsOdc3LMxti9xEFeoGr2eYNPxGCo
 v1IiVImx8LF+5uf11WKO72KGpLH98R2ldf4o+FOh9dFdZfsZF1
 tZPR+0H+RUOfjkUMJ0sLd64nH4Hj2n+6FNm3IFLRv8BbRSf72h
 C7QEgW4qgpqHnzqOaZ/M=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 21 December 2013, Iyappan Subramanian wrote:
> Iyappan Subramanian (5):
>   Documentation: APM X-Gene SoC Ethernet DTS binding documentation
>   arm64: dts: APM X-Gene SoC Ethernet device tree nodes
>   drivers: net: APM X-Gene SoC Ethernet base driver
>   drivers: net: APM X-Gene SoC Ethernet driver error handling
>   drivers: net: APM X-Gene SoC Ethernet driver ethtool support

The third patch (the actual driver) didn't make it to the ARM mailing list.
Maybe it's too large?

	Arnd

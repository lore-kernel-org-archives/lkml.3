Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3LSSs7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 13:48:59 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373Ab3LSSs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 13:48:58 -0500
Message-ID: <52B33EC1.5040901@redhat.com>
Date: Thu, 19 Dec 2013 19:45:21 +0100
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Haiyang Zhang <haiyangz@microsoft.com>
CC: Ben Hutchings <bhutchings@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        KY Srinivasan <kys@microsoft.com>, "olaf@aepfle.de" <olaf@aepfle.de>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "driverdev-devel@linuxdriverproject.org" 
	<driverdev-devel@linuxdriverproject.org>
Subject: Re: [PATCH net-next] hyperv: Add support for Virtual Receive Side
 Scaling (vRSS)
References: <1387405262-18334-1-git-send-email-haiyangz@microsoft.com> <1387475178.1876.29.camel@bwh-desktop.uk.level5networks.com> <ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
In-Reply-To: <ff7f7541d0164d408b3a4278569c593a@DFM-DB3MBX15-06.exchange.corp.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2013 07:36 PM, Haiyang Zhang wrote:

> Thank you for the suggestions! I will re-write the send queue selection, enhance
> the hash calculation, also fix the initialization sequence.

Btw, Toeplitz hash function should either go into lib/hash.c as well or
include/linux/hash.h to avoid ending up w/ various implementations in
multiple places.

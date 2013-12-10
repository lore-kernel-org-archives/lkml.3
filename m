Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab3LJSkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:40:35 -0500
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:39924 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751656Ab3LJSkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:40:33 -0500
X-IronPort-AV: E=Sophos;i="4.93,866,1378882800"; 
   d="scan'208";a="1337716"
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: Michael Chan <mchan@broadcom.com>
To: Natarajan Gurumoorthy <natg@google.com>, <davem@davemloft.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        <nsujir@broadcom.com>, <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <CAGmqidnusPSYt9GHfQVs7SP620jyEN=Aicr1jS3Esb9C5Ov2wA@mail.gmail.com>
References: <1386614601-9453-1-git-send-email-natg@google.com>
	 <1386615608.1752.4.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <CAGmqidkxoi9EEe0uC18QQUXwjFP1e_1MXL7VPk+NtU-Ta6FGUg@mail.gmail.com>
	 <52A633B4.9000307@cogentembedded.com>
	 <1386623253.1752.6.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <1386658724.1752.19.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	 <CAGmqidnusPSYt9GHfQVs7SP620jyEN=Aicr1jS3Esb9C5Ov2wA@mail.gmail.com>
Content-Type: text/plain; charset="cp1252"
Date: Tue, 10 Dec 2013 10:40:32 -0800
Message-ID: <1386700832.1752.21.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-10 at 07:01 -0800, Natarajan Gurumoorthy wrote:
>      The only time I see crashes is after the tg3 driver has been
> loaded into the system. I our use case we are poking around
> /sys/devices/pcixxxx/......../config. 

David, please apply this first patch.

Acked-by: Michael Chan <mchan@broadcom.com>


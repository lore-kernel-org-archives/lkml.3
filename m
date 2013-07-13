Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab3GMKUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 06:20:53 -0400
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:54858 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752258Ab3GMKUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 06:20:52 -0400
Message-ID: <1373710849.1352.29.camel@x61.thuisdomein>
Subject: Re: [PATCH -v2 0/3] Use PCIe DSN to improve pciehp_resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com
Date: Sat, 13 Jul 2013 12:20:49 +0200
In-Reply-To: <51DF6150.8010401@huawei.com>
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
	 <1373552385.1349.2.camel@x61.thuisdomein> <51DF6150.8010401@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jul 2013 10:20:50.0366 (UTC) FILETIME=[A5D885E0:01CE7FB2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing,

On Fri, 2013-07-12 at 09:52 +0800, Yijing Wang wrote:
> Do you wireless card support Device Serial Number ?
> You can confirm it by lspci -vvv.

Yes, it does:
    lspci -vvv -s 03:00 | grep Serial
        Capabilities: [140 v1] Device Serial Number [...]


Paul Bolle


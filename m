Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109Ab3GKKTR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 06:19:17 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:53477 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751478Ab3GKKTQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 06:19:16 -0400
Message-ID: <1373537953.9708.25.camel@x61.thuisdomein>
Subject: Re: [PATCH 2/2] PCI,pciehp: avoid add a device already exist during
 pciehp_resume
From: Paul Bolle <pebolle@tiscali.nl>
To: Yijing Wang <wangyijing@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, jiang.liu@huawei.com,
        Oliver Neukum <oneukum@suse.de>, Gu Zheng <guz.fnst@cn.fujitsu.com>
Date: Thu, 11 Jul 2013 12:19:13 +0200
In-Reply-To: <51DE2C98.5030803@huawei.com>
References: <1373356564-21668-1-git-send-email-wangyijing@huawei.com>
	 <1373357261.1633.4.camel@x61.thuisdomein> <51DE2C98.5030803@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Jul 2013 10:19:14.0150 (UTC) FILETIME=[17ABA060:01CE7E20]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yijing,

On Thu, 2013-07-11 at 11:55 +0800, Yijing Wang wrote:
> Can you provide the lspci -vvv and lspci -xxxx info messages ?
> I want to confirm your hardware information which cause your resume error.
> You can get these messages in any kernel version, that's ok.

Would it be sufficient to send that information just for the two pcie
ports on my laptop, and the wireless card that is present in one of
those two ports?

And would it be OK to send that information off list?

> When you suspend and resume the system, the wireless card is always
> present in pcie slot, right?

Yes. I actually wouldn't even know how to remove it. I only discovered
my wireless card was in a pcie slot because of the error messages at
resume (which started a few releases ago, I think v3.7).


Paul Bolle


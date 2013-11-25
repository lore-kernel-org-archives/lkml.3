Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753593Ab3KYDw7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 22:52:59 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:50090 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553Ab3KYDw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 22:52:56 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCHv2] usb: chipidea: add support for USB OTG controller on TI-NSPIRE
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20131124101205.GA30724@shlinux1.ap.freescale.net>
Date: Mon, 25 Nov 2013 14:52:51 +1100
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux@arm.linux.org.uk>
Content-Transfer-Encoding: 7bit
Message-Id: <B462ABF6-2CD1-423F-8841-4D3A5C555751@gmail.com>
References: <1385278667-91856-1-git-send-email-dt.tangr@gmail.com> <20131124101205.GA30724@shlinux1.ap.freescale.net>
To: Peter Chen <Peter.Chen@freescale.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 24/11/2013, at 9:12 PM, Peter Chen <Peter.Chen@freescale.com> wrote:

> On Sun, Nov 24, 2013 at 06:37:47PM +1100, dt.tangr@gmail.com wrote:
> 
>> +};
>> +
>> +MODULE_DEVICE_TABLE(of, ci_hdrc_nspire_dt_ids);
>> +module_platform_driver(ci_hdrc_nspire_driver);
>> +
>> +MODULE_ALIAS("platform:nspire_usb");
>> +MODULE_ALIAS("platform:ci_hdrc_nspire");
> 
> Just curious, why you need to two alias?

Oops, I must've forgotten to remove this. I'll remove it in the next patch.

> 
> -- 
> 
> Best Regards,
> Peter Chen
> 

Cheers,
Daniel Tang

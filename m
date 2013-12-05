Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab3LEFpJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 00:45:09 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:35107 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734Ab3LEFpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 00:45:05 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20131204121849.GM16025@e106331-lin.cambridge.arm.com>
Date: Thu, 5 Dec 2013 16:45:03 +1100
Cc: "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <ABF0DEB7-5FAD-417D-80EA-BF1A52C3612A@gmail.com>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com> <20131204121849.GM16025@e106331-lin.cambridge.arm.com>
To: Mark Rutland <mark.rutland@arm.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 04/12/2013, at 11:18 PM, Mark Rutland <mark.rutland@arm.com> wrote:

>> 
>> 
>> Required properties:
>> -- compatible: Should be "zevio,nspire-usb"
>> +- compatible: Should be "lsi,nspire-usb"
> 
> Surely this should be lsi,zevio-usb, matching the lsi,zevio-timer
> binding?

You're right. I'll fix up the patch and send it back in.

> 
> Thanks,
> Mark.

Cheers,
Daniel Tang

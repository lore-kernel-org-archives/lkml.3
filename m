Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751982Ab3LEKKw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 05:10:52 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:40642 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab3LEKKq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 05:10:46 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH 1/2] usb: chipidea: fix mistake in device tree binding of nspire-usb to use vendor name 'lsi' instead of SoC name 'zevio'
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <20131205084909.GA25943@shlinux1.ap.freescale.net>
Date: Thu, 5 Dec 2013 21:10:37 +1100
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <FAB4D64E-5DAD-4252-8B24-F076071D0279@gmail.com>
References: <1386148808-15065-1-git-send-email-dt.tangr@gmail.com> <20131204134433.GD1573@shlinux1.ap.freescale.net> <38AC4BA3-DE10-47A6-B3EF-26872A88AABD@gmail.com> <20131205084909.GA25943@shlinux1.ap.freescale.net>
To: Peter Chen <Peter.Chen@freescale.com>
X-Mailer: Apple Mail (2.1510)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/12/2013, at 7:49 PM, Peter Chen <Peter.Chen@freescale.com> wrote:

> On Thu, Dec 05, 2013 at 04:44:13PM +1100, Daniel Tang wrote:
>> Hi,
>> 
>> On 05/12/2013, at 12:44 AM, Peter Chen <Peter.Chen@freescale.com> wrote:
>> 
>>> 
>>> lsi is vendor name, what are zevio and nspire?
>>> Usually, the compatible string should be "vendor_name,soc_name-module_name"
>>> 
>> 
>> Because this port uses documentation from reverse engineering, it's difficult to work out what is SoC specific and what is device specific. The SoC is Zevio but the driver is written for the TI-Nspire.
>> 
> 
> Please wrap the line to 80 characters.
> 
> The driver is written for the TI-Nspire, and you port this driver for
> SoC Zevio platform?

The TI-Nspire runs on the Zevio SoC.

> Since you use chipidea ip, we don't care the usb
> module name at your platform, we only care the soc name which you are
> running, it can detect the SoC platform at runtime.
> 

Yep, that's why the latest patch I sent in renames the device tree 
binding to "lsi,zevio-usb" since zevio is the name of the SoC that the 
TI-Nspire uses.

> At your dts patch, it still uses nspire-usb.
> http://marc.info/?l=linux-usb&m=138614886720024&w=2

I'll send a new one in right now.

> 
> Peter

Cheers,
Daniel Tang
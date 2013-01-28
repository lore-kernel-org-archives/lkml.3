Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755549Ab3A1JzQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 04:55:16 -0500
Received: from mail-ob0-f182.google.com ([209.85.214.182]:52837 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab3A1JzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 04:55:09 -0500
MIME-Version: 1.0
In-Reply-To: <20130122163655.GA21090@kroah.com>
References: <CAMNxYswRsYtRF3kXKR676TZMCUsZPvk0auYTxpGVS2mRLmS8xw@mail.gmail.com>
	<20130122163655.GA21090@kroah.com>
Date: Mon, 28 Jan 2013 15:25:08 +0530
Message-ID: <CAMNxYswbiH-fW6YVvtWEr1W+SWRBU6ELv1bVRfNawpwcy+PZsA@mail.gmail.com>
Subject: Re: Query related to MSR(Magnetic Stripe Reader) Device Driver
From: Priyaranjan Das <priyaranjan456789@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, mankad.maulik@gmail.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On Tue, Jan 22, 2013 at 10:06 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Jan 22, 2013 at 03:02:32PM +0530, Priyaranjan Das wrote:
>> Hi All,
>>
>> I am working on MSR(Magnetic Stripe Reader) for a product . I wish to
>> know whether any MSR( Magnetic Stripe/card Reader) driver is available
>> in the current source or not. I need this for reference. Could anyone
>> please help me?
>
> Most of these types of devices that I have worked with always show up as
> a keyboard device (ps/2 pass-through or a USB hid device.)  What type of
> interface does your device present to the operating system?
>

The MSR will be a part of a SoC. It is  a memory mapped device hence
there is no interface like USB.
MSR IP contains an ADC which the driver will read and interpret the
data. I am planning to write a Driver for the same. Will this driver
fall under drivers/mfd/* ?

Regards,
Priyaranjan

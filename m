Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab3LRJQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 04:16:18 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:57806 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3LRJQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 04:16:14 -0500
Date: Wed, 18 Dec 2013 09:16:09 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laszlo Papp <lpapp@kde.org>
Cc: sameo@linux.intel.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: Simple MFD driver example
Message-ID: <20131218091609.GB14274@lee--X1>
References: <CAOMwXhN5UfR=Y8V3i=A2zSCv7V9sRDd0Z+D1AQFahvRS-mV5Fw@mail.gmail.com>
 <20131216082556.GE18769@lee--X1>
 <CAOMwXhN8fG8YbU53A_U_MyMTyGWfV7NCCtr2a5oCbHdB0iqqmA@mail.gmail.com>
 <20131216150514.GN18769@lee--X1>
 <CAOMwXhMn5W76Dp=EFNHaknXCqZ4q4e7fphgtttx+8U=1Fc_DMQ@mail.gmail.com>
 <20131216164844.GS18769@lee--X1>
 <CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOMwXhPLNVKbRqR2tPQc758zLsh0Lg0D6JUf2yrf+ZosJVANAw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Dec 16, 2013 at 4:48 PM, Lee Jones <lee.jones@linaro.org> wrote:
> > There isn't any documentation that would help you I fear. I'm trying
> > to help you, but you haven't answered my previous question.
> 
> I did intend to answer your question when I was writing that I would
> send some code. See it at the bottom of the email.
> 
> > Do you have a datasheet for the device that you're trying to enable?
> 
> datasheets.maximintegrated.com/en/ds/MAX6650-MAX6651.pdf

What has alluded you to the fact that this is an MFD device?

a) It doesn't look like one to me

b) This device looks like it's already supported in Mainline

> hwmon is already available in the kernel (for which my simple patch
> was rejected). I have just sent out a gpio driver for the gpio bits,
> and see the mfd driver code below.

I'm not sure why it was rejected, but the MAX6651 already looks
supported to me in:
  drivers/hwmon/max6650.c.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

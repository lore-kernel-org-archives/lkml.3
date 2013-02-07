Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3BGDDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 22:03:06 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59528 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab3BGDDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 22:03:03 -0500
MIME-Version: 1.0
In-Reply-To: <20130206163759.GB9952@arwen.pp.htv.fi>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
	<20130206163759.GB9952@arwen.pp.htv.fi>
Date: Thu, 7 Feb 2013 11:03:01 +0800
Message-ID: <CADB-GoJJbV10YGtBU-qWT7XK9SvkgPXkg3x-7oKq9RjSsODuEA@mail.gmail.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com
Cc: gregkh@linuxfoundation.org, stern@rowland.harvard.edu,
        sarah.a.sharp@linux.intel.com, Julia.Lawall@lip6.fr,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 12:38 AM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Feb 06, 2013 at 07:24:01PM +0800, Yuan-Hsin Chen wrote:
>> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>>
>> USB2.0 HCD driver for Faraday FUSBH200
>>
>> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>
> just use ehci-platform.c and avoid the duplication
>
> --
> balbi

Thanks for your advice. I will modify and re-submit it later.

Yuan-Hsin

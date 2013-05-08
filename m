Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753413Ab3EHPLZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 11:11:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62507 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab3EHPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 11:11:24 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1305081039250.1450-100000@iolanthe.rowland.org>
References: <CADB-Go+9SPt8A7E3FsF0TFcF-yARMYX7QDZTsZU4uNSTZWrgqw@mail.gmail.com>
	<Pine.LNX.4.44L0.1305081039250.1450-100000@iolanthe.rowland.org>
Date: Wed, 8 May 2013 23:11:12 +0800
Message-ID: <CADB-Go+ODh8Tw8bXPPRxD0g2raok6-ep6hQU8Ytiy5_5ZR2ZZw@mail.gmail.com>
Subject: Re: [PATCH v4] usb host: Faraday USB2.0 FUSBH200-HCD driver
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: gregkh@linuxfoundation.org, sarah.a.sharp@linux.intel.com,
        Felipe Balbi <balbi@ti.com>, Julia.Lawall@lip6.fr,
        USB list <linux-usb@vger.kernel.org>, linux-kernel@vger.kernel.org,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, May 8, 2013 at 10:40 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Wed, 8 May 2013, Yuan-Hsin Chen wrote:
>
>> Hi,
>>
>> Are there any advice?
>> Thanks.
>>
>> On Fri, Apr 26, 2013 at 5:37 PM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
>> > FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
>> > FUSBH200 is an ehci-like controller with some differences.
>> > First, register layout of FUSBH200 is incompatible with EHCI.
>> > Furthermore, FUSBH200 is lack of siTDs which means iTDs
>> > are used for both HS and FS ISO transfer.
>
> As far as I'm concerned, this can be merged.

Thanks for your great help.

>
> Alan Stern
>

Yuan-Hsin

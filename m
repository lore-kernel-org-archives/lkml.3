Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756375Ab3EHOkK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 10:40:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:53604 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756172Ab3EHOkJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 10:40:09 -0400
Date: Wed, 8 May 2013 10:40:08 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
cc: gregkh@linuxfoundation.org, <sarah.a.sharp@linux.intel.com>,
        Felipe Balbi <balbi@ti.com>, <Julia.Lawall@lip6.fr>,
        USB list <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>,
        ratbert <ratbert.chuang@gmail.com>,
        =?UTF-8?B?Sm9obiBGZW5nLUhzaW4gQ2hpYW5nKOaxn+WzsOiIiCk=?= 
	<john453@faraday-tech.com>
Subject: Re: [PATCH v4] usb host: Faraday USB2.0 FUSBH200-HCD driver
In-Reply-To: <CADB-Go+9SPt8A7E3FsF0TFcF-yARMYX7QDZTsZU4uNSTZWrgqw@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1305081039250.1450-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 May 2013, Yuan-Hsin Chen wrote:

> Hi,
> 
> Are there any advice?
> Thanks.
> 
> On Fri, Apr 26, 2013 at 5:37 PM, Yuan-Hsin Chen <yuanlmm@gmail.com> wrote:
> > FUSBH200-HCD is an USB2.0 hcd for Faraday FUSBH200.
> > FUSBH200 is an ehci-like controller with some differences.
> > First, register layout of FUSBH200 is incompatible with EHCI.
> > Furthermore, FUSBH200 is lack of siTDs which means iTDs
> > are used for both HS and FS ISO transfer.

As far as I'm concerned, this can be merged.

Alan Stern


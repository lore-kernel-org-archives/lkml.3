Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab3JKBvm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:51:42 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:54571 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3JKBvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <5256A1DE.8010709@ti.com>
References: <1380911156-14112-1-git-send-email-dmurphy@ti.com>
	<CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>
	<52519E7A.40804@ti.com>
	<CACVXFVNAB3VnmdoP_LGJsBjQ17j1aoqKMsBE7LRt65OqROeRUQ@mail.gmail.com>
	<525698CC.3060406@ti.com>
	<CACVXFVP-KgqcNTnk+JZsLc188pYk6iUXvW6=kPXNaurSuevGeA@mail.gmail.com>
	<5256A1DE.8010709@ti.com>
Date: Fri, 11 Oct 2013 09:51:38 +0800
Message-ID: <CACVXFVM2V6k6r4D5BPj7FyrBcGzopT5QVfww5fEUz6CfHMQTBQ@mail.gmail.com>
Subject: Re: [PATCH] usbnet: smsc95xx: Add device tree input for MAC address
From: Ming Lei <tom.leiming@gmail.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: Steve Glendinning <steve.glendinning@shawell.net>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>, mugunthanvnm@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 8:47 PM, Dan Murphy <dmurphy@ti.com> wrote:
>
> Is there a board that has 2 built in smsc devices?

I don't know, maybe there isn't, but driver should be generic enough, and
as I said it is a generic problem, and people are discussing it, so suggest
to read previous discussions first before post your V2.

Below link is one I remembered, but I think you can find more:

https://lkml.org/lkml/2013/8/11/100

> This is all dependent on what the dev.id is of udev.

I am not sure why it depends on udev, and udev can't
see the device util it is added to system.

Thanks,
-- 
Ming Lei

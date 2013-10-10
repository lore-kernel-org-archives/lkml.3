Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433Ab3JJMjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:39:09 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63357 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221Ab3JJMjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:39:07 -0400
MIME-Version: 1.0
In-Reply-To: <525698CC.3060406@ti.com>
References: <1380911156-14112-1-git-send-email-dmurphy@ti.com>
	<CACVXFVOVMvP=3y9h2Jrqn2sBQdKOZtrhQDAFYkdHKXFgQj=d0Q@mail.gmail.com>
	<52519E7A.40804@ti.com>
	<CACVXFVNAB3VnmdoP_LGJsBjQ17j1aoqKMsBE7LRt65OqROeRUQ@mail.gmail.com>
	<525698CC.3060406@ti.com>
Date: Thu, 10 Oct 2013 20:39:06 +0800
Message-ID: <CACVXFVP-KgqcNTnk+JZsLc188pYk6iUXvW6=kPXNaurSuevGeA@mail.gmail.com>
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

On Thu, Oct 10, 2013 at 8:08 PM, Dan Murphy <dmurphy@ti.com> wrote:
>
> You are correct I don't expect a match for PnP devices only devices that are hard wired.
>
> After thinking of it I should move the OF code below the EEPROM code as the EEPROM should take preference over the DT code.
>
> I will need to post V2 for that.

Your patch still doesn't deal with two smsc95xx devices built in
one board.

The problem is a generic one, looks it is better to do it when OF supports
discoverable bus.


Thanks,
-- 
Ming Lei

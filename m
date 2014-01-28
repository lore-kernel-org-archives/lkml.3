Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134AbaA1OUm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:20:42 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:64695 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbaA1OUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:20:40 -0500
Message-ID: <1390918834.22403.16.camel@host5.omatika.ru>
Subject: Re: [PATCH 01/11] resolve PXA<->8250 serial device address conflict
From: Sergei Ianovich <ynvich@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Date: Tue, 28 Jan 2014 18:20:34 +0400
In-Reply-To: <20140128141437.GB8713@xo-6d-61-c0.localdomain>
References: <1385879185-22455-1-git-send-email-ynvich@gmail.com>
	 <1385879185-22455-2-git-send-email-ynvich@gmail.com>
	 <20140128141437.GB8713@xo-6d-61-c0.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-01-28 at 15:14 +0100, Pavel Machek wrote:
> Yes, please. I was hitting the same issue with Sharp Zaurus and bluetooth
> CF card... Bluetooth card had 8250 inside...

A better implementation is posted as v3 of the patch.

http://linux-kernel.2935.n7.nabble.com/PATCH-00-11-ARM-support-for-ICP-DAS-LP-8x4x-tp761919p773485.html

It would be great if you could test that patch add post back the
results.


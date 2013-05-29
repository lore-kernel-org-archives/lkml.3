Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965295Ab3E2SKH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 14:10:07 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:45409 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964986Ab3E2SJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 14:09:58 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 29 May 2013 20:09:37 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: How to get driver_data of struct ieee1394_device_id in kernel
 driver module?
Message-ID: <20130529200937.362c69d4@stein>
In-Reply-To: <20130526225757.GA32606@kroah.com>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
	<20130526225757.GA32606@kroah.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On May 27 Greg Kroah-Hartman wrote:
> Why not pass it in the probe() function, like USB and PCI does?  That
> way, if the driver wants to save it for that device, it can.

I will try that, probably at the weekend.
-- 
Stefan Richter
-=====-===-= -=-= ===-=
http://arcgraph.de/sr/

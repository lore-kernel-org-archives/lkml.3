Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752084AbaBIRhe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 12:37:34 -0500
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:55439 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751516AbaBIRhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 12:37:32 -0500
Message-ID: <1391967449.5315.7.camel@x220>
Subject: Re: [PATCH] [media] si4713: Remove "select SI4713"
From: Paul Bolle <pebolle@tiscali.nl>
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 09 Feb 2014 18:37:29 +0100
In-Reply-To: <52F7B522.1000205@xs4all.nl>
References: <1391957777.25424.15.camel@x220> <52F79C37.5030000@xs4all.nl>
	 <1391959624.25424.29.camel@x220> <52F7B522.1000205@xs4all.nl>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 09 Feb 2014 17:37:30.0479 (UTC) FILETIME=[9B7DBFF0:01CF25BD]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-02-09 at 18:04 +0100, Hans Verkuil wrote:
> The i2c module is loaded by v4l2_i2c_new_subdev_board().

I see. Thanks.

But now I wonder: is I2C_SI4713 useful on itself? Would anyone use
si4713.ko without using either radio-usb-si4713.ko or
radio-platform-si4713.ko? Because it seems that if what people actually
use is radio-usb-si4713.ko or radio-platform-si4713.ko than I2C_SI4713
could be made a 'select only' Kconfig symbol (that won't show up in
menuconfig), couldn't it?


Paul Bolle


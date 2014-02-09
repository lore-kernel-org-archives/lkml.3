Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaBIRph (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 12:45:37 -0500
Received: from smtp-vbr10.xs4all.nl ([194.109.24.30]:2566 "EHLO
	smtp-vbr10.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751548AbaBIRpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 12:45:36 -0500
Message-ID: <52F7BE9D.7090007@xs4all.nl>
Date: Sun, 09 Feb 2014 18:45:01 +0100
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [media] si4713: Remove "select SI4713"
References: <1391957777.25424.15.camel@x220> <52F79C37.5030000@xs4all.nl>  <1391959624.25424.29.camel@x220> <52F7B522.1000205@xs4all.nl> <1391967449.5315.7.camel@x220>
In-Reply-To: <1391967449.5315.7.camel@x220>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2014 06:37 PM, Paul Bolle wrote:
> On Sun, 2014-02-09 at 18:04 +0100, Hans Verkuil wrote:
>> The i2c module is loaded by v4l2_i2c_new_subdev_board().
> 
> I see. Thanks.
> 
> But now I wonder: is I2C_SI4713 useful on itself? Would anyone use
> si4713.ko without using either radio-usb-si4713.ko or
> radio-platform-si4713.ko? Because it seems that if what people actually
> use is radio-usb-si4713.ko or radio-platform-si4713.ko than I2C_SI4713
> could be made a 'select only' Kconfig symbol (that won't show up in
> menuconfig), couldn't it?

It's possible to create an out-of-tree driver that uses the i2c si4713
driver. So yes, it should be possible to just select the i2c driver without
any of the others.

Regards,

	Hans

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729Ab3EGFZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:25:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50729 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751190Ab3EGFZs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:25:48 -0400
Message-ID: <5188905A.4020703@zytor.com>
Date: Mon, 06 May 2013 22:25:46 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: linux-input@vger.kernel.org
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Lenovo Yoga 13 touchpad regression
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The touchpad on Lenovo Yoga 13 seems to have broken some time between 
3.4 and the current kernel.  The dmesg is full of spewage:

[  256.246481] atkbd serio0: Use 'setkeycodes e03e <keycode>' to make it 
known.
[  256.251473] atkbd serio0: Unknown key released (translated set 2, 
code 0xbe on isa0060/serio0

... about once per second; I am wondering if the touchpad is spewing 
output onto the keyboard channel or if there is something else wrong.

I have tried i8042.nomux and i8042.noloop to no effect.

Unless someone has a better idea I'll try to do a bisect.

	-hpa

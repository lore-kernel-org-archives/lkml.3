Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557AbbAVS22 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 13:28:28 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:52084 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473AbbAVS2Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 13:28:25 -0500
From: Peter Korsgaard <peter@korsgaard.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Max Filippov <jcmvbkbc@gmail.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-ocores: add common clock support
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
	<20150122144522.GF3413@katana>
	<CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
	<20150122150717.GJ3413@katana>
Date: Thu, 22 Jan 2015 19:28:21 +0100
In-Reply-To: <20150122150717.GJ3413@katana> (Wolfram Sang's message of "Thu,
	22 Jan 2015 16:07:17 +0100")
Message-ID: <87wq4e7jqy.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Wolfram" == Wolfram Sang <wsa@the-dreams.de> writes:

 >> The clock here is not the i2c bus clock, but the clock input of the

 > Yes, what I would expect from a clk-property :)

 >> controller. The function ocores_init initializes the prescaler register of
 >> the controller so that the bus clock equals 100kHz (internal clock
 >> runs at 500kHz):

 > 'clock-frequency' usually describes the I2C bus speed. So, for ocores,
 > it describes speed of the clock for the controller? That would be
 > ouch...

Indeed :/

Looking back in the history, the device tree patch originally used a
custom "clock_khz" property until some guy told him to use
clock-frequency ;)

https://lists.ozlabs.org/pipermail/devicetree-discuss/2010-November/003650.html

As far as I can see I wasn't CC'ed on that patch.

-- 
Bye, Peter Korsgaard

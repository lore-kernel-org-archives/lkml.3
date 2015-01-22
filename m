Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754702AbbAVUga (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 15:36:30 -0500
Received: from mail-oi0-f49.google.com ([209.85.218.49]:55921 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbbAVUg0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 15:36:26 -0500
MIME-Version: 1.0
In-Reply-To: <20150122185711.GA14880@katana>
References: <1421230899-7843-1-git-send-email-jcmvbkbc@gmail.com>
	<20150122144522.GF3413@katana>
	<CAMo8Bf+XJY_bY+OB2i_SZQmAavwERG39BR8FVj202V-E3UidPg@mail.gmail.com>
	<20150122150717.GJ3413@katana>
	<87wq4e7jqy.fsf@dell.be.48ers.dk>
	<20150122185711.GA14880@katana>
Date: Thu, 22 Jan 2015 23:36:25 +0300
Message-ID: <CAMo8BfJCPQWa-AGODDO5o2XZU3d-BbaxjSSG9SOoMzoXpYtr-A@mail.gmail.com>
Subject: Re: [PATCH] i2c-ocores: add common clock support
From: Max Filippov <jcmvbkbc@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Peter Korsgaard <peter@korsgaard.com>, Peter Korsgaard <jacmet@sunsite.dk>,
        linux-i2c@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 9:57 PM, Wolfram Sang <wsa@the-dreams.de> wrote:
> 2?) a new binding is present to specify the IP clock speed:
>         - is this needed? is somebody using the driver without CCF?
>         - if so, the new binding is parsed and evaluated
>         - I couldn't find an existing binding to specify a clock speed.
>           Please have a look, too. Otherwise we need to introduce sth
>           like "opencores,ip-clock-khz" probably.
>         - "clock-frequency" is describing the bus speed as usual

ePAPR document says that clock-frequency 'specifies the frequency
of a clock in Hz', not identifying which clock. Outside i2c drivers
subtree it is commonly used to specify input clock frequency of IP
blocks, even for bus controllers, e.g. SPI.

-- 
Thanks.
-- Max

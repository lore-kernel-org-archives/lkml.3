Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610AbaD2IQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 04:16:17 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:42726 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327AbaD2IQO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 04:16:14 -0400
MIME-Version: 1.0
In-Reply-To: <DC148C5AA1CEBA4E87973D432B1C2D8825E1F6C5@P3PWEX4MB008.ex4.secureserver.net>
References: <1398562558-5354-1-git-send-email-chase.southwood@gmail.com>
	<1398562711-6313-1-git-send-email-chase.southwood@gmail.com>
	<DC148C5AA1CEBA4E87973D432B1C2D8825E1F6C5@P3PWEX4MB008.ex4.secureserver.net>
Date: Tue, 29 Apr 2014 03:16:13 -0500
Message-ID: <CA+jnaaU4PxXgRFrLOdgaXxs0cG6ypG2h=TzaUMa7BPmmZ516kQ@mail.gmail.com>
Subject: Re: [PATCH 6/6] staging: comedi: addi_apci_2032: remove use of devpriv->s_EeParameters
From: Chase Southwood <chase.southwood@gmail.com>
To: Hartley Sweeten <HartleyS@visionengravers.com>
Cc: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "abbotti@mev.co.uk" <abbotti@mev.co.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hartley,

Ah geez...my brain got all tangled looking at old git commits for
other addi-data drivers.  I apologize for this silly mistake.  I'll
fix that title and send a new version of the patchset tomorrow.

Thanks,
Chase

On Mon, Apr 28, 2014 at 12:59 PM, Hartley Sweeten
<HartleyS@visionengravers.com> wrote:
> On Saturday, April 26, 2014 6:39 PM, Chase Southwood wrote:
>> This driver no longer reads the eeprom to find the board specific data,
>> all the necessary data is in the boardinfo. Use the boardinfo directly
>> instead of passing through devpriv->s_EeParameters.
>>
>> Signed-off-by: Chase Southwood <chase.southwood@gmail.com>
>> Cc: Ian Abbott <abbotti@mev.co.uk>
>> Cc: H Hartley Sweeten <hsweeten@visionengravers.com>
>
> Chase,
>
> The subject does not match the patch.
>
> Regards,
> Hartley

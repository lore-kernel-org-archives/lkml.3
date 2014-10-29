Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023AbaJ2Nq6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 09:46:58 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:53970 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932958AbaJ2Nq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 09:46:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAGb2v65gSq+kMnVZMAvXkF6+ARiFE1qRpQ9SFDThfXCg_kERsQ@mail.gmail.com>
References: <cover.1414444953.git.rbyshko@gmail.com> <668c1b5541fc0175957573bd5f8d40dd2eaccae1.1414444953.git.rbyshko@gmail.com>
 <20141028214756.GF9255@lukather> <CAGb2v65gSq+kMnVZMAvXkF6+ARiFE1qRpQ9SFDThfXCg_kERsQ@mail.gmail.com>
From: Roman Byshko <rbyshko@gmail.com>
Date: Wed, 29 Oct 2014 14:46:34 +0100
Message-ID: <CAMXmWBkrTwHTXi3Unb3dHLWT2AjC=6u8KLj0ZOHduyMAG8YmLg@mail.gmail.com>
Subject: Re: [PATCH 1/5] phy: sun4i: add support for USB phy0
To: Chen-Yu Tsai <wens@csie.org>
Cc: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

sorry for missing Signed-offs, they will be added, of course.

>>> +     /* Regulation 45 ohms */
>>> +     if (phy->index == 0)
>>> +             sun4i_usb_phy_write(phy, PHY_RES45_CAL_EN, 0x01, 1);
>>
>> What is this code supposed to do?
>>
>> Some define for this bit and/or a better comment would be nice.
>
> From Allwinner's sources: "Enable/Disable USB res45 Calibration"
>
> which I think refers to the internal 45 ohm termination resistors
> for the USB data lines. But I'm not an expert on USB hardware.

Same with me. I will however change the comment to make it more informative.

Thanks for your review,
Roman

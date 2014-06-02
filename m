Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752748AbaFBTzF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 15:55:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33787 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbaFBTzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 15:55:01 -0400
MIME-Version: 1.0
In-Reply-To: <5389AB89.9080305@kernel.org>
References: <1401311175-12784-1-git-send-email-reyad.attiyat@gmail.com>
 <1401311175-12784-3-git-send-email-reyad.attiyat@gmail.com> <5389AB89.9080305@kernel.org>
From: Reyad Attiyat <reyad.attiyat@gmail.com>
Date: Mon, 2 Jun 2014 14:54:40 -0500
Message-ID: <CA+BWVUSHUT9r=RHX3ubn6Byq=cX4wkfHsoc4Kh1FFFuLvW6GSw@mail.gmail.com>
Subject: Re: [PATCH 2/3] IIO: Add iio_chan modifier for True/Magnetic North
 HID usages
To: Jonathan Cameron <jic23@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Jonathan,
>
> I think we need the naming to explicitly mention north_magnetic instead
> of just north.  Whilst it is obvious what north means when you have north
> true alongside it, it won't be so obvious if one just has the north
> attribute
> to see in a particular driver - if anything I'd have the true as the one
> that was simply called north (as it might not be coming from a magnetometer
> thought obviously that's the most common source)   I'd also rather the enum
> entries
> were
> IIO_MOD_NORTH_MAGN
> IIO_MOD_NORTH_TRUE
> IIO_MOD_NORTH_MAGN_TILT_COMP
> IIO_MOD_NORTH_TRUE_TILT_COMP
>
> It is definitely feasible that they will not come from magnetometers -
> a differential bearing is common on GPS units.

Makes sense to me. I will update the patches with your suggestions. Thanks.

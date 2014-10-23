Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbaJWKjQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 06:39:16 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:56233 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaJWKjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 06:39:13 -0400
MIME-Version: 1.0
In-Reply-To: <8eb45695460b1131ed1abf72700667aa98e6b5b6.1413858979.git.bvandre@gmail.com>
References: <cover.1413858979.git.bvandre@gmail.com>
	<8eb45695460b1131ed1abf72700667aa98e6b5b6.1413858979.git.bvandre@gmail.com>
Date: Thu, 23 Oct 2014 13:39:11 +0300
X-Google-Sender-Auth: GTA1Ai6ECYfmM5H80m4RGC9T2-I
Message-ID: <CAEnQRZAcKhMbHg7B5ExnNG2zgixYV5jEPsKPZuCZS-Z+jKfxeg@mail.gmail.com>
Subject: Re: [PATCH 1/2] Staging: iio: adc: fix line over 80 characters
From: Daniel Baluta <daniel.baluta@intel.com>
To: Brian Vandre <bvandre@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jonathan Cameron <jic23@kernel.org>,
        alexandre.belloni@free-electrons.com, linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 5:48 AM, Brian Vandre <bvandre@gmail.com> wrote:
> This fixes the checkpatch.pl warning:
> WARNING: line over 80 characters
>
> Signed-off-by: Brian Vandre <bvandre@gmail.com>

As a part of OPW [1] IIO cleanup project [2] we analyzed all checkpatch.pl
warnings / errors and we decided not to fix some of them as there is no
obvious improvement.

This "line over 80 characters" warning was one of them. In my opinion
it doesn't make code easier to read.

thanks,
Daniel.

[1] http://kernelnewbies.org/OPWIntro
[2] http://kernelnewbies.org/IIO_cleanup

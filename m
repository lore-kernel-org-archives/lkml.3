Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751926AbaBGAKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 19:10:10 -0500
Received: from mail-ve0-f172.google.com ([209.85.128.172]:49602 "EHLO
	mail-ve0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaBGAKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 19:10:08 -0500
MIME-Version: 1.0
In-Reply-To: <1387338410-5930-1-git-send-email-dusonlin@emc.com.tw>
References: <1387338410-5930-1-git-send-email-dusonlin@emc.com.tw>
Date: Thu, 6 Feb 2014 16:10:07 -0800
X-Google-Sender-Auth: y3Oii44CafK7VckKMiG8XuH-sCU
Message-ID: <CANLzEktFwEfvn52V7Up_PthnJzR3f-ni_0-_krpmx=jZJfo=EA@mail.gmail.com>
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
From: Benson Leung <bleung@chromium.org>
To: Duson Lin <dusonlin@emc.com.tw>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>, agnescheng@chromium.org,
        phoenix@emc.com.tw
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 7:46 PM, Duson Lin <dusonlin@emc.com.tw> wrote:
> This driver adds support for elan i2c/smbus touchpad found on some laptops PC
>
> Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
Reviewed-by: Benson Leung <bleung@chromium.org>

Hi Dmitry,

This driver has been posted for a little while now. I've reviewed it,
and it is consistent with the cyapa.c driver that I submitted. Could
you take another look at this?

Thanks,
-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

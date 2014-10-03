Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001AbaJCVaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:30:19 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:45964 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347AbaJCVaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:30:17 -0400
MIME-Version: 1.0
In-Reply-To: <20141003210357.GB4987@dtor-ws>
References: <1389064083-11018-1-git-send-email-dusonlin@emc.com.tw>
	<20141003210357.GB4987@dtor-ws>
Date: Fri, 3 Oct 2014 14:30:16 -0700
X-Google-Sender-Auth: qxriT2TJ3jxChE4i7Ybua-dSUq0
Message-ID: <CANLzEkutVdtF8cWmXMF9STyD6x9JUZJ9xH0R8VneG5h8vTy32Q@mail.gmail.com>
Subject: Re: [PATCH v2] Input: add i2c/smbus driver for elan touchpad
From: Benson Leung <bleung@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Duson Lin <dusonlin@emc.com.tw>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        agnescheng@chromium.org, phoenix@emc.com.tw,
        "Jeff.Chuang" <jeff.chuang@emc.com.tw>, devicetree@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 2:03 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Input: driver for Elan I2C/SMbus touchpad
>
> From: Duson Lin <dusonlin@emc.com.tw>
>
> This driver supports Elan I2C/SMbous touchpads found in some laptops and

s/SMbous/SMBus

> also in many Chromebooks.
>
> Signed-off-by: Duson Lin <dusonlin@emc.com.tw>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>

Reviewed-by: Benson Leung <bleung@chromium.org>


-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org

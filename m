Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759632Ab3BYVxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 16:53:50 -0500
Received: from mail-oa0-f41.google.com ([209.85.219.41]:49938 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759465Ab3BYVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 16:53:46 -0500
MIME-Version: 1.0
In-Reply-To: <20130220181815.GB15152@core.coreip.homeip.net>
References: <1361381079-26747-1-git-send-email-sjg@chromium.org>
	<1361381079-26747-6-git-send-email-sjg@chromium.org>
	<20130220181815.GB15152@core.coreip.homeip.net>
Date: Mon, 25 Feb 2013 13:53:43 -0800
X-Google-Sender-Auth: bT9lpI1Qdco8Q1Q14hlvCPVjFNE
Message-ID: <CAPnjgZ0r93Pzrj5bHFmM1BjkNzKLRVJoW=TGdvOHOwpgLbjv=Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/6] Input: matrix-keymap: Add function to read the new
 DT binding
From: Simon Glass <sjg@chromium.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Javier Martinez Canillas <javier@dowhile0.org>,
        Sourav Poddar <sourav.poddar@ti.com>, Felipe Balbi <balbi@ti.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        linux-input@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Wed, Feb 20, 2013 at 10:18 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Wed, Feb 20, 2013 at 09:24:38AM -0800, Simon Glass wrote:
>> We now have a binding which adds two parameters to the matrix keypad DT
>> node. This is separate from the GPIO-driven matrix keypad binding, and
>> unfortunately incompatible, since that uses row-gpios/col-gpios for the
>> row and column counts.
>>
>> So the easiest option here is to provide a function for non-GPIO drivers
>> to use to decode the binding.
>>
>> Note: We could in fact create an entirely separate structure to hold
>> these two fields, but it does not seem worth it, yet. If we have more
>> parameters then we can add this, and then refactor each driver to hold
>> such a structure.
>>
>> Signed-off-by: Simon Glass <sjg@chromium.org>
>> Tested-by: Sourav Poddar <sourav.poddar@ti.com> (v2)
>
> Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> I suppose the EC driver will go through MFD tree, right?

Yes I expect so.

Regards,
Simon

>
> --
> Dmitry

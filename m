Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756522AbaFREaU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 00:30:20 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:63193 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbaFREaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 00:30:18 -0400
MIME-Version: 1.0
In-Reply-To: <CAPnjgZ0h4vKfwcw7w=wDt_6Vv6G+nQYKbris_0ucLUoAjpE+VQ@mail.gmail.com>
References: <1402954800-28215-1-git-send-email-dianders@chromium.org>
	<1402954800-28215-8-git-send-email-dianders@chromium.org>
	<CAPnjgZ0Qj=5=5xtBoK7b+1Qn+VbBeeSPr+K5uiSMv3fU2ejXfQ@mail.gmail.com>
	<CAD=FV=VCe+mf4fM79R2iunrvsS_A=G4Ha1z6M2z7J4Vq1e6=1A@mail.gmail.com>
	<CAPnjgZ0h4vKfwcw7w=wDt_6Vv6G+nQYKbris_0ucLUoAjpE+VQ@mail.gmail.com>
Date: Tue, 17 Jun 2014 21:30:17 -0700
X-Google-Sender-Auth: fjR_lfkdxKFFc6fj6K3GPDT2iak
Message-ID: <CAD=FV=Xa2pb6cFSbHoXAaS8LXdVO-uv+RCXMs2HmobgutSrNwQ@mail.gmail.com>
Subject: Re: [PATCH 07/10] mfd: cros_ec: cleanup: remove unused fields from
 struct cros_ec_device
From: Doug Anderson <dianders@chromium.org>
To: Simon Glass <sjg@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>,
        Wolfram Sang <wsa@the-dreams.de>, Mark Brown <broonie@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        lk <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon,

On Tue, Jun 17, 2014 at 9:25 PM, Simon Glass <sjg@chromium.org> wrote:
> Hi Doug,
>
> On 17 June 2014 21:22, Doug Anderson <dianders@chromium.org> wrote:
>>
>> Simon,
>>
>> On Tue, Jun 17, 2014 at 8:39 PM, Simon Glass <sjg@chromium.org> wrote:
>> > Hi Doug,
>> >
>> > On 16 June 2014 14:39, Doug Anderson <dianders@chromium.org> wrote:
>> >> From: Bill Richardson <wfrichar@chromium.org>
>> >>
>> >> struct cros_ec_device has a superfluous "name" field. We can get all the
>> >> debugging info we need from the existing ec_name and phys_name fields, so
>> >> let's take out the extra field.
>> >
>> > Except that it no longer prints I2C/SPI - i.e. the transport that is
>> > used. Is that not considered important?
>>
>> Before this change:
>>   [    1.895472] cros-ec-spi spi2.0: Chrome EC (SPI)
>>
>> After this change:
>>   [    1.910671] cros-ec-spi spi2.0: Chrome EC device registered
>>
>>
>> I think having SPI in the name twice is probably enough.  ;)
>
> Ah that helps! Could have been in the commit message.
>
> Reviewed-by: Simon Glass <sjg@chromium.org>

If I re-spin the series I'll add it.  I think the new message was in
the original commit in the "TEST=" clause and I left it out.  I
probably should have added it in with the proper wording...

-Doug

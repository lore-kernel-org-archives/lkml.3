Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab3FZIVn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:21:43 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:52347 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678Ab3FZIVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:21:40 -0400
MIME-Version: 1.0
In-Reply-To: <51C9A412.1050802@ti.com>
References: <1372159970-6361-1-git-send-email-ruslan.bilovol@ti.com>
	<51C9A412.1050802@ti.com>
Date: Wed, 26 Jun 2013 11:21:39 +0300
X-Google-Sender-Auth: Tr8HHJZpkP_RZZiZ3hiZ9vV8t04
Message-ID: <CAB=otbQMeOo-5nwORTzPU_+1Ez_=MaQWLRxfnAREhKttvbxAmw@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: DTS: OMAP4: Add OMAP4 Blaze Tablet support
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Dan Murphy <dmurphy@ti.com>
Cc: b-cousson@ti.com, tony@atomide.com, benoit.cousson@linaro.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Tue, Jun 25, 2013 at 5:07 PM, Dan Murphy <dmurphy@ti.com> wrote:
> On 06/25/2013 06:32 AM, Ruslan Bilovol wrote:
>>
>> The OMAP4 Blaze Tablet is TI OMAP4 processor-based
>> development platform in a tablet formfactor.
>> The platform contains many of the features found in
>> present-day handsets (such as audio, video, wireless
>> functions and user interfaces) and in addition
>> contains features for software development and test.
>
> Why do we want to send this upstream?
> What is the advantage to having this supported?
>
> I don't believe we need to add another community board.  We have a SDP and
> Panda.

Because:
a) it is still widely used for prototyping devices
b) you can still buy it from svtronics
c) it has different set of devices on board so we have ability to
   work with things like:
  - widescreen high-resolution LCD panel
  - different touchscreen controllers
  - gpio keys (on 'Blaze Tablet')
  - another set of sensors
  - HS USB Host related stuff etc
d) some features may be easily accessible only on BlazeTalet board
    (comparing to Panda/SDP), like USB HSIC connection
e) it is shipped with OMAP4470, support of which we are going to send upstream
f) with Device Tree it's easy to support this board :)

Best regards,
Ruslan

>
> Dan
>
> <snip>
>
> --
> ----------------------------------------------
> Dan Murphy
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755592Ab3HMIlc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 04:41:32 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62415 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755429Ab3HMIl2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 04:41:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130712065734.GE31802@arwen.pp.htv.fi>
References: <1373416455-30358-1-git-send-email-jwerner@chromium.org>
	<20130710052534.GB15674@arwen.pp.htv.fi>
	<CAODwPW9dmwpXeyBeVER9azsh2uW3NXLTbDtz3mJaXrvSwb6opg@mail.gmail.com>
	<20130712065734.GE31802@arwen.pp.htv.fi>
Date: Tue, 13 Aug 2013 14:11:27 +0530
Message-ID: <CAHbNUh0Sa-atYMHbhEUX2vnVAcsdBJxw9RRzAp+6vqE8hi=p1w@mail.gmail.com>
Subject: Re: [PATCH] usb: phy: samsung-usb2: Toggle HSIC GPIO from device tree
From: Tushar Behera <tushar.behera@linaro.org>
To: balbi@ti.com
Cc: Julius Werner <jwerner@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Praveen Paneri <p.paneri@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Doug Anderson <dianders@chromium.org>,
        Olof Johansson <olofj@chromium.org>,
        Vincent Palatin <vpalatin@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2013 12:27, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Wed, Jul 10, 2013 at 10:42:27AM -0700, Julius Werner wrote:
>> Hi Felipe,
>>
>> This is intended to pull down a reset signal line, not to switch power
>> to the device. I could implement that with the regulator framework
>> too, but I think that would just be confusing and harder to understand
>> without providing any benefit. It's really just a plain old GPIO.
>
> alright, in that case how about using drivers/reset/ ?
>

IIUC, reset-gpio driver only provides APIs for reset controls (reset,
assert, deassert). We still need to find out the location from where
we would be calling the reset function.

-- 
Tushar Behera

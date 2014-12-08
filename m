Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755572AbaLHQOY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 11:14:24 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:53760 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709AbaLHQOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 11:14:21 -0500
MIME-Version: 1.0
In-Reply-To: <20141208105732.GA14346@localhost>
References: <1417089434-11274-1-git-send-email-octavian.purdila@intel.com>
	<20141205101741.GD11445@localhost>
	<CAE1zotJwn6kVv8s5Dk+wxQxuGDKSjaqMqYY0M0Q0uODQypSsoA@mail.gmail.com>
	<20141205120610.GG11445@localhost>
	<CAE1zotKGAvd9oKz5_McihnPcpH-n4Rc4s0r=jm2wb26-dD8Dsg@mail.gmail.com>
	<20141208105732.GA14346@localhost>
Date: Mon, 8 Dec 2014 18:14:19 +0200
Message-ID: <CAE1zotJPkTsvwqYEsfHHrdgdBW+03M20nqGzUL8bQXBfn70tBg@mail.gmail.com>
Subject: Re: [PATCH] mfd: dln2: add suspend/resume functionality
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 8, 2014 at 12:57 PM, Johan Hovold <johan@kernel.org> wrote:
> On Fri, Dec 05, 2014 at 03:05:45PM +0200, Octavian Purdila wrote:
>> On Fri, Dec 5, 2014 at 2:06 PM, Johan Hovold <johan@kernel.org> wrote:
>> > On Fri, Dec 05, 2014 at 01:51:17PM +0200, Octavian Purdila wrote:
>> >> On Fri, Dec 5, 2014 at 12:17 PM, Johan Hovold <johan@kernel.org> wrote:
>
>> >> > And surely you need to resubmit the read urbs in resume, or you will
>> >> > never receive any more data.
>> >> >
>> >> > How did you test this patch?
>> >> >
>> >>
>> >> The resume cb is not called in my setup (kvm), only reset_resume.
>> >
>> > Please make sure to test your patches on proper hardware.
>>
>> It was tested with the proper hardware, I was just testing it in the
>> setup we use, which is kvm with USB pass through.
>
> I was referring to your kvm setup.
>

I see the same behavior (reset_resume called) when testing on bare
bone hardware. BTW, KVM allows me to test more thoroughly, as I can
use custom SSDT tables required by i2c devices to find their IRQs.

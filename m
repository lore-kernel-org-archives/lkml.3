Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaK1MJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 07:09:21 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:34083 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017AbaK1MJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 07:09:19 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-a5-547865ec372e
Message-id: <547865EA.5010700@samsung.com>
Date: Fri, 28 Nov 2014 13:09:14 +0100
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "b.zolnierkie@samsung.com" <b.zolnierkie@samsung.com>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        "cooloney@gmail.com" <cooloney@gmail.com>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "sakari.ailus@iki.fi" <sakari.ailus@iki.fi>,
        "s.nawrocki@samsung.com" <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH/RFC v8 08/14] DT: Add documentation for exynos4-is
 'flashes' property
References: <1417166286-27685-1-git-send-email-j.anaszewski@samsung.com>
 <1417166286-27685-9-git-send-email-j.anaszewski@samsung.com>
 <20141128111404.GB25883@leverpostej>
In-reply-to: <20141128111404.GB25883@leverpostej>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpjkeLIzCtJLcpLzFFi42I5/e/4Zd03qRUhBsf+y1hsnLGe1eLozolM
	FvOPnGO16H+zkNXi3KuVjBZnm96wW1zeNYfNYuubdYwWPRu2slosvX6RyeLuqaNsFhOmr2Wx
	aN17hN1i966nrBaH37SzWpzZv5LNQcBjzbw1jB6X+3qZPHbOusvusXL5FzaPw18XsnhsWtXJ
	5rFn/g9Wj74tqxg9Vqz+zu7xeZNcAFcUl01Kak5mWWqRvl0CV8az6V8YC6YIV/w+fYqtgfEJ
	fxcjJ4eEgInEmXvPWSBsMYkL99azdTFycQgJLGWUOPj/OTuE85FR4t37ViaQKl4BLYnmV3PY
	QGwWAVWJy12NYN1sAoYSP1+8BqsRFYiQ+HN6HytEvaDEj8n3wGpEBNQlenZ9YQEZyizwmFVi
	+5mDzCAJYYFoib9vZkBtW8coca//DViCE2jqxcXnwbYxC1hLrJy0jRHClpfYvOYt8wRGgVlI
	lsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV56XrJ+bmbGCFx93UH49JjVocYBTgYlXh4
	J1hWhAixJpYVV+YeYpTgYFYS4XWPBwrxpiRWVqUW5ccXleakFh9iZOLglGpg3HrhTEriXZMG
	niPxfvsCm+WEa/qspBVv/XqTmij4R5Nv8caVOzIfrOdbonR52WWn7e/Pe/zn3Vq4/NQ6Y611
	Ahvtb9a+mu255eqBXdtNuS89++n3KCilJtLI4fQhubQ7uh2bAj7zXt3sUtg8/WzmChV2tZTl
	m+28lm/te3Ba1y3qKvvNj4k83EosxRmJhlrMRcWJALAJYVqZAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 12:14 PM, Mark Rutland wrote:
> On Fri, Nov 28, 2014 at 09:18:00AM +0000, Jacek Anaszewski wrote:
>> This patch adds a description of 'flashes' property
>> to the samsung-fimc.txt.
>>
>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: <devicetree@vger.kernel.org>
>> ---
>>   .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> index 922d6f8..4b7ed03 100644
>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
>>   and the port B deactivated and for the state "active-b" it should be the other
>>   way around.
>>
>> +Optional properties:
>> +
>> +- flashes - array of strings with flash led names; the name has to
>> +	    be same with the related led label
>> +	    (see Documentation/devicetree/bindings/leds/common.txt)
>> +
>
> Why is this not an array of phandles to the LED nodes? That's much
> better than strings.

This is because a single flash led device can control many sub-leds,
which are represented by child nodes in the Device Tree.
Every sub-led is registered as a separate LED Flash class device
in the LED subsystem, but in fact they share the same struct device
and thus have access only to the parent's phandle. The LED Flash
class devices are wrapped by V4L2 sub-devices and register
asynchronously within a media device. Since the v4l2_subdev structure
has a 'name' field, it is convenient to initialize it with
parsed 'label' property of a child led node and match the
sub-devices in the media device basing on it.

> Also, I only seem to have recevied the documentation patches and none of
> the code -- in future when posting RFC DT patches, please Cc for the
> code too as it's useful context.

Of course, I'll keep it in mind.

Regards,
Jacek

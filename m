Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaK1OLL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 09:11:11 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:63242 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751608AbaK1OLI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 09:11:08 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-64-547882799c31
Message-id: <54788278.7080101@samsung.com>
Date: Fri, 28 Nov 2014 15:11:04 +0100
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
 <20141128111404.GB25883@leverpostej> <547865EA.5010700@samsung.com>
 <20141128123003.GE25883@leverpostej>
In-reply-to: <20141128123003.GE25883@leverpostej>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphkeLIzCtJLcpLzFFi42I5/e/4Zd3KpooQg6XX9S02zljPanF050Qm
	i/lHzrFa9L9ZyGpx7tVKRouzTW/YLS7vmsNmsfXNOkaLng1bWS2WXr/IZHH31FE2iwnT17JY
	tO49wm6xe9dTVovDb9pZLc7sX8nmIOCxZt4aRo/Lfb1MHjtn3WX3WLn8C5vH4a8LWTw2repk
	89gz/werR9+WVYweK1Z/Z/f4vEkugCuKyyYlNSezLLVI3y6BK6Pj6UnGgpMSFXvWJzUwThfp
	YuTkkBAwkfi1dBYzhC0mceHeerYuRi4OIYGljBINrXeZIZyPjBLNLw8xgVTxCmhJ7JraCmaz
	CKhKbJ02hxXEZhMwlPj54jVYXFQgQuLP6X2sEPWCEj8m32MBsUUE1CV6dn1hARnKLPCYVWL7
	mYNgq4UFoiX+vpnBDrHtC6PEvoWvgO7g4OAEmvqlowikhlnAWmLlpG2MELa8xOY1b5knMArM
	QrJjFpKyWUjKFjAyr2IUTS1NLihOSs810itOzC0uzUvXS87P3cQIibmvOxiXHrM6xCjAwajE
	wzvBsiJEiDWxrLgy9xCjBAezkghveglQiDclsbIqtSg/vqg0J7X4ECMTB6dUA2P0GvXoM56y
	t36JTllTrGOfnMwgJBEYn7nd8Y3g5ufb2hW3TI3qEc4X/CdgevrlvcSXk/1u1ase6nRnn3ru
	Z/Ivyfb7629MLkmZk81WERO93cdryyMfG4+Ip/EfeTd6S/e9qt68c9WKrW/v92zakXTQ5Ur7
	oZxkmflhtyM2GF3TWVnC5HG62l6JpTgj0VCLuag4EQAgiXPRlwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2014 01:30 PM, Mark Rutland wrote:
> On Fri, Nov 28, 2014 at 12:09:14PM +0000, Jacek Anaszewski wrote:
>> On 11/28/2014 12:14 PM, Mark Rutland wrote:
>>> On Fri, Nov 28, 2014 at 09:18:00AM +0000, Jacek Anaszewski wrote:
>>>> This patch adds a description of 'flashes' property
>>>> to the samsung-fimc.txt.
>>>>
>>>> Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
>>>> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
>>>> Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>>> Cc: Rob Herring <robh+dt@kernel.org>
>>>> Cc: Pawel Moll <pawel.moll@arm.com>
>>>> Cc: Mark Rutland <mark.rutland@arm.com>
>>>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>>>> Cc: Kumar Gala <galak@codeaurora.org>
>>>> Cc: <devicetree@vger.kernel.org>
>>>> ---
>>>>    .../devicetree/bindings/media/samsung-fimc.txt     |    7 +++++++
>>>>    1 file changed, 7 insertions(+)
>>>>
>>>> diff --git a/Documentation/devicetree/bindings/media/samsung-fimc.txt b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> index 922d6f8..4b7ed03 100644
>>>> --- a/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> +++ b/Documentation/devicetree/bindings/media/samsung-fimc.txt
>>>> @@ -40,6 +40,12 @@ should be inactive. For the "active-a" state the camera port A must be activated
>>>>    and the port B deactivated and for the state "active-b" it should be the other
>>>>    way around.
>>>>
>>>> +Optional properties:
>>>> +
>>>> +- flashes - array of strings with flash led names; the name has to
>>>> +	    be same with the related led label
>>>> +	    (see Documentation/devicetree/bindings/leds/common.txt)
>>>> +
>>>
>>> Why is this not an array of phandles to the LED nodes? That's much
>>> better than strings.
>>
>> This is because a single flash led device can control many sub-leds,
>> which are represented by child nodes in the Device Tree.
>> Every sub-led is registered as a separate LED Flash class device
>> in the LED subsystem, but in fact they share the same struct device
>> and thus have access only to the parent's phandle.
>
> But that's a Linux infrastrcture issue, no? You don't have to use the
> node from the struct device to find the relevant phandle.

Right.

>> The LED Flash
>> class devices are wrapped by V4L2 sub-devices and register
>> asynchronously within a media device. Since the v4l2_subdev structure
>> has a 'name' field, it is convenient to initialize it with
>> parsed 'label' property of a child led node and match the
>> sub-devices in the media device basing on it.
>
> While that might be convenient, I don't think it's fantastic to use that
> to describe the relationship, as this leaks Linux internals (e.g. I can
> refer to a name that doesn't exist in the DT but happens to be what
> Linux used, and it would work). Also, are the labels guaranteed to be
> globally unique?

The labels are used for initializing class device name and kernel
doesn't allow to initialize two devices with same names.
This implies that labels are guaranteed to be globally unique.
Unless I am missing something.

Regards,
Jacek

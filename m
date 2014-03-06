Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaCFQc5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 11:32:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:53490 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750839AbaCFQcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 11:32:55 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-fc-5318a332e5f5
Message-id: <5318A331.2070603@samsung.com>
Date: Thu, 06 Mar 2014 17:32:49 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v6 0/8] Move device tree graph parsing helpers to drivers/of
References: <1394011242-16783-1-git-send-email-p.zabel@pengutronix.de>
 <53170C00.20200@ti.com> <1394030554.8754.31.camel@paszta.hi.pengutronix.de>
 <20140306141657.GB21483@n2100.arm.linux.org.uk>
 <20140306121721.6186dafb@samsung.com> <5318988C.2030004@samsung.com>
 <1394122879.3622.47.camel@paszta.hi.pengutronix.de>
In-reply-to: <1394122879.3622.47.camel@paszta.hi.pengutronix.de>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsVy+t/xa7pGiyWCDX7PVLaYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXouL6+Qt7t47wWLRuvcIu8X6+bfYHHg8
	Wpp72Dw+fIzzmN0xk9Vj06pONo871/awefT/NfDo27KK0eP4je1MHp83yQVwRnHZpKTmZJal
	FunbJXBlPH22hrXgl0TFzEucDYwTRLoYOTkkBEwkrmyawARhi0lcuLeeDcQWEljKKDFjcWEX
	IxeQ/YlR4uy/1YwgCV4BLYkTV/eDNbAIqEpMvHoKLM4mYCjRe7QPzBYViJB4dXYiC0S9oMSP
	yffAbBGg3qdX7rGBDGUWOMUscfTrXuYuRg4OYYEAiSV7GSGWHWaSeD/pJNgVnAIOEg1TloPZ
	zALqEpPmLWKGsOUlNq95yzyBUWAWkh2zkJTNQlK2gJF5FaNoamlyQXFSeq6RXnFibnFpXrpe
	cn7uJkZI3Hzdwbj0mNUhRgEORiUeXoMFEsFCrIllxZW5hxglOJiVRHgr5wKFeFMSK6tSi/Lj
	i0pzUosPMTJxcEo1MLr9fVJh/of18envP6dtrLjUZm77aS7/vwKN2WdL9YKaml7Llpda8TkU
	v3gZk3GdXVK08r7J/YNXvHmzK+x/J1ZIXug6EXAn1f25WsvxqarB/zXbeloidz798SZi+8a3
	25YFHFjY51DsaPfY98vp6izbSVMezU+4ejr6De+TX2+v6t9nskuUUVViKc5INNRiLipOBAB8
	DIukeQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/14 17:21, Philipp Zabel wrote:
> Am Donnerstag, den 06.03.2014, 16:47 +0100 schrieb Sylwester Nawrocki:
>> On 06/03/14 16:17, Mauro Carvalho Chehab wrote:
>>> Em Thu, 06 Mar 2014 14:16:57 +0000
>>> Russell King - ARM Linux <linux@arm.linux.org.uk> escreveu:
>>>>> On Wed, Mar 05, 2014 at 03:42:34PM +0100, Philipp Zabel wrote:
>>>>>>> Am Mittwoch, den 05.03.2014, 13:35 +0200 schrieb Tomi Valkeinen:
> [...]
>>>>>>>>> So, as I've pointed out, I don't agree with the API, as it's too limited
>>>>>>>>> and I can't use it, but as this series is (mostly) about moving the
>>>>>>>>> current API to a common place, it's fine for me.
>>>>>>>>>
>>>>>>>>> Acked-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
>>>>>>>
>>>>>>> Thanks. I'll be happy to help expanding the API to parse ports
>>>>>>> individually, once this gets accepted.
>>>>>>>
>>>>>>> Mauro, Guennadi, are you fine with how this turned out? I'd like to get
>>>>>>> your acks again, for the changed location.
>>>
>>> From my side, there's nothing on such code that is V4L2 specific.
>>> Moving it to drivers/of makes sense on my eyes.
>>>
>>> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>>
>> I'm OK with patches 1...5, 8, so for these:
>>
>> Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>
>> Regarding the simplified version of the binding, I thought we should
>> leave 'port' instead of 'endpoint' node. This could cover more hardware
>> configurations. Are there any users of this simplified binding queued
>> for v3.15 ? If not, perhaps we can postpone it and discuss it a bit more
>> (sorry, couldn't find time to comment on that earlier) ?
> 
> Since Tomi needs the separate port/endpoint iteration anyway, 
> postponing the simple bindings shouldn't hurt. I'll (re)submit them
> together in a second series.

Ok, thanks.

>>>>> I'll need those acks before I can even think about queuing up the
>>>>> imx-drm bits.
>>>>>
>>>>> Another way to deal with this is if this gets pulled into the V4L tree
>>>>> from Philipp's git tree, I can also pull that in myself.  What mustn't
>>>>> happen is for these to be committed independently as patches.
>>>
>>> If everyone agrees, I actually prefer have this patch applied on my tree,
>>> in order to avoid some potential merge conflicts at the merge window,
>>> as we might have other drivers and changes there touching on those API
>>> calls (I'm aware of a series of patches from Sylwester with some DT
>>> stuff on it. Not sure if it would be affected by such changes or not).
>>
>> Yes, it's going to conflict with my patch series. I thought it could be
>> put onto a stable a topic branch, e.g. at git://linuxtv.org/media_tree.git,
>> which could be then pulled into the media master branch and anywhere
>> else it is needed ?
> 
> Mauro, are you ok with handling the conflict in the merge, or should I
> rebase on top of the media tree after you merged Sylwester's changes?

I could rebase and resolve any conflicts before sending my pull request
to Mauro. I don't think it's a good idea to rebase this series onto the
media tree, since it is touching drivers/of.

--
Regards,
Sylwester


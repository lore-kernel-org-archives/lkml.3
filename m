Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965291AbaCUOKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 10:10:16 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:58375 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbaCUOKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 10:10:13 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-f0-532c4843fc1a
Message-id: <532C4841.9090508@samsung.com>
Date: Fri, 21 Mar 2014 15:10:09 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: [PATCH v4 1/3] [media] of: move graph helpers from
 drivers/media/v4l2-core to drivers/of
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
 <3632624.gNVi6QOfGx@avalon> <20140320222347.CAB6DC412EA@trevor.secretlab.ca>
 <2848953.vVjghJyYNE@avalon> <532C408D.4070002@ti.com>
In-reply-to: <532C408D.4070002@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xK7rOHjrBBt++CFvMP3KO1eL9xnlM
	Fgf+7GC0ONv0ht2ic+ISdovLu+awWfRs2Mpqcfsyr8XFdfIWd++dYLHYOu8co0Xr3iPsFuvn
	32Jz4PVoae5h89g56y67x4ePcR6zO2ayemxa1cnmcefaHjaP/r8GHn1bVjF6HL+xncnj8ya5
	AK4oLpuU1JzMstQifbsEroyJn3exFaxgq3h5agVTA2MzaxcjB4eEgInEzv2RXYycQKaYxIV7
	69m6GLk4hASWMkrcuLKdGSQhJPCJUWL3k2gQm1dAS+LYzUWMIDaLgKrE4vXNYDabgKFE79E+
	MFtUIEJi7sTNbBD1ghI/Jt9jAbFFgHo/ne1hBVnALPCVWeL3vP9MIAlhgXSJzl9/GCGWnWWU
	uLNKAMTmFFCTuLynnR3EZhbQkdjfOo0NwpaX2LzmLfMERoFZSHbMQlI2C0nZAkbmVYyiqaXJ
	BcVJ6bmGesWJucWleel6yfm5mxghsfRlB+PiY1aHGAU4GJV4eCs4tYOFWBPLiitzDzFKcDAr
	ifB22ukEC/GmJFZWpRblxxeV5qQWH2Jk4uCUamBsmXopWaRM+O+7HXe1TFawlAf5J9ZN2CFh
	3TYja3bBPEYtHb/KXdz3V33k9xFbeUp6xf7c6vufNWtebC2+vfFOTsbs/sMRrsmrJEO/7T3f
	ccJD7ekDY1f+fV1bzcsmXd/L9zax70Hg7+vFyR83N1cxSIdYHnPQ95r+Of/1B5uvS1t5Pibf
	8OZQYinOSDTUYi4qTgQAclC9coMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/03/14 14:37, Tomi Valkeinen wrote:
> On 21/03/14 00:32, Laurent Pinchart wrote:
> 
>> > The OF graph bindings documentation could just specify the ports node as 
>> > optional and mandate individual device bindings to specify it as mandatory or 
>> > forbidden (possibly with a default behaviour to avoid making all device 
>> > bindings too verbose).
>
> Isn't it so that if the device has one port, it can always do without
> 'ports', but if it has multiple ports, it always has to use 'ports' so
> that #address-cells and #size-cells can be defined?
> 
> If so, there's nothing left for the individual device bindings to decide.

Wouldn't it make the bindings even more verbose ? Letting the individual
device bindings to decide sounds more sensible to me.

--
Thanks,
Sylwester

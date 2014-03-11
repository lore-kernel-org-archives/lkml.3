Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515AbaCKNrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 09:47:23 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:21829 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168AbaCKNrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 09:47:21 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-41-531f13e6768c
Message-id: <531F13E2.3040603@samsung.com>
Date: Tue, 11 Mar 2014 14:47:14 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Rob Herring <robh+dt@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        devicetree@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH v4 3/3] Documentation: of: Document graph bindings
References: <1393340304-19005-1-git-send-email-p.zabel@pengutronix.de>
 <1393340304-19005-4-git-send-email-p.zabel@pengutronix.de>
 <530DE8A9.9050809@ti.com> <1393426623.3248.70.camel@paszta.hi.pengutronix.de>
 <530DFF4C.8080807@ti.com> <20140307181132.B2D71C40A88@trevor.secretlab.ca>
 <531AE46A.2060808@ti.com> <20140308122532.1AED9C40612@trevor.secretlab.ca>
 <531D6178.3070906@ti.com>
In-reply-to: <531D6178.3070906@ti.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBLMWRmVeSWpSXmKPExsVy+t/xq7rPhOWDDU5+NbaYf+Qcq8X7jfOY
	LA782cFocbbpDbtF58Ql7BaXd81hs+jZsJXV4vZlXouL6+Qt7t47wWLRuvcIu8X6+bfYHHg8
	Wpp72Dw+fIzzmN0xk9Vj06pONo871/awefT/NfDo27KK0eP4je1MHp83yQVwRnHZpKTmZJal
	FunbJXBlNHxqYyuYxFGx89sOpgbGTWxdjJwcEgImEsuOt0DZYhIX7q0Hsrk4hASWMkos3rye
	HcL5xCjxasY9dpAqXgEtiQnLV7OC2CwCqhL3nhwAs9kEDCV6j/YxgtiiAhESr85OZIGoF5T4
	MfkemC0iUCPx+dBSJhCbWeAHk8SSjWogtrCAm8SDsydZIJZ1Mkv0b20CO4lTQE3izKqTLBAN
	OhL7W6exQdjyEpvXvGWewCgwC8mOWUjKZiEpW8DIvIpRNLU0uaA4KT3XUK84Mbe4NC9dLzk/
	dxMjJHa+7GBcfMzqEKMAB6MSD+8Kf7lgIdbEsuLK3EOMEhzMSiK8F+8BhXhTEiurUovy44tK
	c1KLDzEycXBKNTCmFWYx7xc9/cN151SHojSxS5r9X+PTNU4tui2dJLWvQPTljuKkkv+B8rsm
	2E+5GVM/bzbfR8aXAi9dnVVsXx6Jf5EuouT8+Jwi82nL6NXS++3Yvxta9zDM874dMzuCYyIf
	v85d+1X3rmR93zM/v/RA3WkOKesjW0q1A4Iab9uciTsplm/X8kiJpTgj0VCLuag4EQChl2CH
	ewIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 07:53, Tomi Valkeinen wrote:
> On 08/03/14 14:25, Grant Likely wrote:
> 
>> Sure. If endpoints are logical, then only create the ones actually
>> hooked up. No problem there. But nor do I see any issue with having
>> empty connections if the board author things it makes sense to have them
>> in the dtsi.
> 
> I don't think they are usually logical, although they probably might be
> in some cases.

The endpoint nodes are supposed to be logical, they just group properties
describing a port's configuration.

> As I see it, a "port" is a group of pins in a hardware component, and
> two endpoints define a connection between two ports, which on the HW
> level are the wires between the ports.
> 
> So a port with two endpoints is a group of pins, with wires that go from
> the same pins to two different components.

It could be approximated like this, but I don't think it is needed.
I would rather stay with only port nodes mapped to hardware and the
endpoint nodes logical.

--
Regards,
Sylwester

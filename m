Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933Ab3EPMxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 08:53:48 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:62510 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702Ab3EPMxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 08:53:45 -0400
MIME-Version: 1.0
In-Reply-To: <2750806.COjXX3GeT0@avalon>
References: <1368529236-18199-1-git-send-email-prabhakar.csengg@gmail.com>
 <11504129.E8jKKy4N2e@avalon> <CA+V-a8ti58gdPR-fUEqgBvUQ=1GkoTUyLj9UK4D5aVwHv2R6mA@mail.gmail.com>
 <2750806.COjXX3GeT0@avalon>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 May 2013 18:23:24 +0530
Message-ID: <CA+V-a8vQhJs5KNTAOzbPcxfv4AjQCTzSdXCYJTAvf0cFTykrwQ@mail.gmail.com>
Subject: Re: [PATCH v3] media: i2c: tvp514x: add OF support
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Thu, May 16, 2013 at 6:20 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Hi Prabhakar,
>
> On Thursday 16 May 2013 18:13:38 Prabhakar Lad wrote:
>> On Thu, May 16, 2013 at 5:40 PM, Laurent Pinchart wrote:
>> > Hi Prabhakar,
>>
>> [Snip]
>>
>> >> +
>> >> +     pdata = devm_kzalloc(&client->dev, sizeof(*pdata), GFP_KERNEL);
>> >> +     if (!pdata)
>> >
>> > I've started playing with the V4L2 OF bindings, and realized that should
>> > should call of_node_put() here.
>>
>> you were referring  of_node_get() here rite ?
>
> No, I'm referring to of_node_put(). The v4l2_of_get_next_endpoint() function
> mentions
>
>  * Return: An 'endpoint' node pointer with refcount incremented. Refcount
>  * of the passed @prev node is not decremented, the caller have to use
>  * of_node_put() on it when done.
>
Ahh I see thanks for clarifying, I'll fix it  for v3.

Regards,
--Prabhakar Lad

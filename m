Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757616Ab3EYSCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 May 2013 14:02:39 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:37644 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491Ab3EYSCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 May 2013 14:02:36 -0400
Message-ID: <51A0FCB6.7060609@gmail.com>
Date: Sat, 25 May 2013 20:02:30 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: LMML <linux-media@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH RFC v2] media: OF: add sync-on-green endpoint property
References: <1368710287-8741-1-git-send-email-prabhakar.csengg@gmail.com> <519F4AE7.8000003@gmail.com> <CA+V-a8tMQnjh=8qaRoNhwkdrcoTCK2zofTkCOd79hAMoz5qK2A@mail.gmail.com> <51A0C6A8.5090302@gmail.com> <CA+V-a8tqQGk1v_QdSsn2rt-OJY5PxoFmr1LLkp1bQQb3GuerMA@mail.gmail.com>
In-Reply-To: <CA+V-a8tqQGk1v_QdSsn2rt-OJY5PxoFmr1LLkp1bQQb3GuerMA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2013 04:26 PM, Prabhakar Lad wrote:
>> Thus it might make sense to have only following integer properties (added
>> >  as needed):
>> >
>> >  composite-sync-active
>> >  sync-on-green-active
>> >  sync-on-comp-active
>> >  sync-on-luma-active
>> >
>> >  This would allow to specify polarity of each signal and at the same time
>> >  the parsing code could derive synchronisation type. A new field could be
>> >  added to struct v4l2_of_parallel_bus, e.g. sync_type and it would be filled
>> >  within v4l2_of_parse_endpoint().
>> >
> I am OK with this option. and I hope you meant "struct
> v4l2_of_bus_parallel" instead
> of " struct v4l2_of_parallel_bus" and to fill sync_type within
> v4l2_of_parse_parallel_bus()
> and not in v4l2_of_parse_endpoint().

Yes, that's what I meant, sorry for this confusion.

Regards,
Sylwester

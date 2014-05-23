Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbaEWRMt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 13:12:49 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2405 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230AbaEWRMr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 13:12:47 -0400
Message-ID: <537F8152.5050705@xs4all.nl>
Date: Fri, 23 May 2014 19:11:46 +0200
From: Hans Verkuil <hverkuil@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.4.0
MIME-Version: 1.0
To: Chaitanya Hazarey <c@24.io>, Dan Carpenter <dan.carpenter@oracle.com>
CC: Luca Risolia <luca.risolia@studio.unibo.it>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: [PATCH] Staging: Media: sn9c102: Fixed a pointer declaration
 coding style issue
References: <CADadk9FjRgvBqO4FMpz8UrBAh8pV8t4SZnKPVBwyjHzBUw+0=Q@mail.gmail.com>	<20140523071005.GR15585@mwanda> <CADadk9HqHKNxTOEqmEVGDTq2gqxLB3=R25GHjNR+BV+apH8izA@mail.gmail.com>
In-Reply-To: <CADadk9HqHKNxTOEqmEVGDTq2gqxLB3=R25GHjNR+BV+apH8izA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 06:59 PM, Chaitanya Hazarey wrote:
> Hey Dan,
> 
> Sorry my bad, will resubmit the patch in a proper manner with the
> required corrections.
> 

Don't bother. This patch: http://comments.gmane.org/gmane.linux.drivers.driver-project.devel/48570
has just been merged and that has the same fixes as your patch.

But thanks anyway :-)

Regards,

	Hans

> Thanks for looking into this.
> 
> Thanks,
> 
> Chaitanya
> 
> On Fri, May 23, 2014 at 12:10 AM, Dan Carpenter
> <dan.carpenter@oracle.com> wrote:
>> On Thu, May 22, 2014 at 04:11:38PM -0700, Chaitanya wrote:
>>> Fixed the ERROR thrown off by checkpatch.pl.
>>>
>>
>> Put the error message here, or say what it was.
>>
>>> Signed-off-by: Chaitanya Hazarey <c@24.io>
>>
>> Could you change your email client so it has your last in the From:
>> header?
>>
>> This patch doesn't apply.  Read this:
>> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/Documentation/email-clients.txt
>>
>> regards,
>> dan carpenter
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab3GXAr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:47:59 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42811 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758194Ab3GXAr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <20130724003439.GE31864@blackmetal.musicnaut.iki.fi>
References: <20130723225715.GD31864@blackmetal.musicnaut.iki.fi>
 <1374621001.3031.1@driftwood> <20130724003439.GE31864@blackmetal.musicnaut.iki.fi>
From: Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Tue, 23 Jul 2013 20:47:25 -0400
X-Google-Sender-Auth: nuSkZI74tTVcinh-t76c2cor9kI
Message-ID: <CAP=VYLrXq_cgR-+aXVK5wkK9BQHNoYjCzHR6d1jtsYJ70qVRZQ@mail.gmail.com>
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that hasn't changed
To: Aaro Koskinen <aaro.koskinen@iki.fi>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 23, 2013 at 8:34 PM, Aaro Koskinen <aaro.koskinen@iki.fi> wrote:
> Hi,
>
> On Tue, Jul 23, 2013 at 06:10:01PM -0500, Rob Landley wrote:
>> On 07/23/2013 05:57:15 PM, Aaro Koskinen wrote:
>> >Is there any file describing the needed tools (and minimum versions) to
>> >_build_ the kernel? I agree that trying to describe such for the run-time
>> >userspace does not belong to the kernel tree, but the required/supported
>> >versions of build tools should be still maybe documented...
>>
>> Documentation/changes _is_ the file that describes the kernel's
>> build-time prerequisites.
>
> So, in that case the file should not be deleted.

Or, we could create a real required-packages.txt that isn't a decade out
of date (and poorly named), and have that in turn reference the arch
specific files with the arch specific data.

C'mon folks, have an open mind here.   Put yourself in the perspective
of the new user, and the issues that he/she faces.  Try and forget the
knowledge that you implicitly have gained of linux over time.   Pointing
these new users at this ancient Changes file is a good way to simply
drive them away.

We can do better.  I know we can.  And I know we all want that exact
same thing once we cut away all the BS.

Thanks,
Paul.
---

>
> A.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

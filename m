Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454AbaD0TFw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:05:52 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:63798 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaD0TFu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:05:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140427173932.GP26890@mwanda>
References: <1398532162-23006-1-git-send-email-laurent.navet@gmail.com>
	<20140426204704.GB17562@mguzik.redhat.com>
	<20140426213137.GM26890@mwanda>
	<20140426215945.GC17562@mguzik.redhat.com>
	<20140427173932.GP26890@mwanda>
Date: Sun, 27 Apr 2014 21:05:50 +0200
Message-ID: <CAH7P7NgrEim8oDVy1_UDRdZHnrEp4RTFtMgcUzu+mBDOYNM_yw@mail.gmail.com>
Subject: Re: [PATCH] staging: line6: fix possible overrun
From: Laurent Navet <laurent.navet@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Mateusz Guzik <mguzik@redhat.com>, tiwai@suse.de,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank's for your answers,
will try to look deeper,

>> >
>> > If we want to sovle the truncation issue then we need to think of
>> > shorter names for BassPODxtLive, BassPODxtPro, PODStudioUX1, and
>> > PODStudioUX2.
>> >
>>
>> In that case I suggest compile time assertions that ids and names fit
>
> That sounds like some magic code which I would love to see.  :)
>
>>  and a WARN_ON + -EINVAL in line6_init_audio to catch future
>>  offenders.
>
> Returning -EINVAL is a bad idea because it would break the driver
> completely and make it unusable.
>
>>
>> As a side note I'm not sure if pod_try_init from
>> drivers/staging/line6/pod.c
>> cleans up properly after failed line6_init_audio.
>
> Yeah.  It doesn't seem to clean up at all.
>

Laurent Navet.
-- 
« On ne résout pas un problème avec les modes de pensée qui l’ont engendré. »
« You cannot solve current problems with current thinking. Current
problems are the result of current thinking »

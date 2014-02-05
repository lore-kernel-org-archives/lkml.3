Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaBEUJS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:09:18 -0500
Received: from mail-yk0-f173.google.com ([209.85.160.173]:36991 "EHLO
	mail-yk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755514AbaBEUJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:09:12 -0500
MIME-Version: 1.0
In-Reply-To: <20140205195236.GM11667@thunk.org>
References: <201402050915.34607.gheskett@wdtv.com> <201402051324.59495.gheskett@wdtv.com>
 <20140205195236.GM11667@thunk.org>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 5 Feb 2014 14:08:50 -0600
Message-ID: <CAAMCDecOdOMRpx6-EHOjKfGO_PQHD83APOzLOwHGxHO40CL_fQ@mail.gmail.com>
Subject: Re: possible viri in tarballs?
To: "Theodore Ts'o" <tytso@mit.edu>, Gene Heskett <gheskett@wdtv.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gene,

How big is the file you have?      Here is what I have, and this is
from several different kernels.

 wc gadget_multi.txt
 150  830 5482 gadget_multi.tx

cksum gadget_multi.txt
3973522114 5482 gadget_multi.txt

ls -l gadget_multi.txt
-rw-rw-r-- 1 root root 5482 Dec 20 09:51 gadget_multi.txt

If you size/cksum is different something modified your file


On Wed, Feb 5, 2014 at 1:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Wed, Feb 05, 2014 at 01:24:59PM -0500, Gene Heskett wrote:
>> >/home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
>> >MBL_400944.UNOFFICIAL FOUND
>>
>> You will see more history.
>>
>> So that file needs sanitized.  I was under the impression that a file with
>> the .txt extension was supposed to be pure ascii text, but its loaded to
>> the gills with some sort of markup crap.  And I have at least 20 copies of
>> it.
>
> Huh?   There are lines with
>
> * Overview
>
> ...
>
> ** Linux host drivers
>
> ...
>
> in that file, sure.  But I'd hardly call that "loaded to the gills
> with markup crap".
>
> If the file was had any amount of XML or XHTML2, that would be markup
> crap.  But some Twiki style ascii markup is hardly a problem -- it
> looks just fine when viewed in a text reader.
>
>                                  - Ted
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

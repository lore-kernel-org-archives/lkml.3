Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755212AbaBEUtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 15:49:20 -0500
Received: from mail.wdtv.com ([66.118.69.84]:39233 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261AbaBEUtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 15:49:17 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: linux-kernel@vger.kernel.org
Subject: Re: possible viri in tarballs?
Date: Wed, 5 Feb 2014 15:49:14 -0500
References: <201402050915.34607.gheskett@wdtv.com> <20140205195236.GM11667@thunk.org> <CAAMCDecOdOMRpx6-EHOjKfGO_PQHD83APOzLOwHGxHO40CL_fQ@mail.gmail.com>
In-Reply-To: <CAAMCDecOdOMRpx6-EHOjKfGO_PQHD83APOzLOwHGxHO40CL_fQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201402051549.14410.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 February 2014, Roger Heflin wrote:
>Gene,
>
>How big is the file you have?      Here is what I have, and this is
>from several different kernels.
>
> wc gadget_multi.txt
> 150  830 5482 gadget_multi.tx
>
>cksum gadget_multi.txt
>3973522114 5482 gadget_multi.txt
>
>ls -l gadget_multi.txt
>-rw-rw-r-- 1 root root 5482 Dec 20 09:51 gadget_multi.txt
>
>If you size/cksum is different something modified your file

They crosscheck as identical to yours.
>
>On Wed, Feb 5, 2014 at 1:52 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Wed, Feb 05, 2014 at 01:24:59PM -0500, Gene Heskett wrote:
>>> >/home/gene/src/linux-3.2.40/Documentation/usb/gadget_multi.txt:
>>> >MBL_400944.UNOFFICIAL FOUND
>>> 
>>> You will see more history.
>>> 
>>> So that file needs sanitized.  I was under the impression that a file
>>> with the .txt extension was supposed to be pure ascii text, but its
>>> loaded to the gills with some sort of markup crap.  And I have at
>>> least 20 copies of it.
>> 
>> Huh?   There are lines with
>> 
>> * Overview
>> 
>> ...
>> 
>> ** Linux host drivers
>> 
>> ...
>> 
>> in that file, sure.  But I'd hardly call that "loaded to the gills
>> with markup crap".
>> 
>> If the file was had any amount of XML or XHTML2, that would be markup
>> crap.  But some Twiki style ascii markup is hardly a problem -- it
>> looks just fine when viewed in a text reader.
>> 
>>                                  - Ted
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>> in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-kernel"
>in the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>Please read the FAQ at  http://www.tux.org/lkml/


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.


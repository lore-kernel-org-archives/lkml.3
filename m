Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755003AbaJUJ1f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 05:27:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41992 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753484AbaJUJ1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 05:27:34 -0400
Message-ID: <544626FE.6090703@redhat.com>
Date: Tue, 21 Oct 2014 11:27:26 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: checkpatch false positive
References: <54461602.4000705@redhat.com> <1413880105.12828.3.camel@perches.com>
In-Reply-To: <1413880105.12828.3.camel@perches.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/21/2014 10:28 AM, Joe Perches wrote:
> On Tue, 2014-10-21 at 10:14 +0200, Hans de Goede wrote:
>> Hi,
>>
>> Checkpatch gives the following warning:
>>
>> WARNING: added, moved or deleted file(s), does MAINTAINERS need updating?
>> #31:
>> new file mode 100644
>>
>> total: 0 errors, 1 warnings, 352 lines checked
>>
>> 0001-input-Add-new-sun4i-lradc-keys-driver.patch has style problems, please review.
>>
>> If any of these errors are false positives, please report
>> them to the maintainer, see CHECKPATCH in MAINTAINERS.
>>
>> On a patch of mine, even though it updates MAINTAINERS properly, it would
>> be nice if checkpatch would check for a hunk updating MAINTAINERS, and then
>> would not issue this warning (note my perl-foo is way too weak to fix this
>> myself).
>>
>> I've attached the patch triggering the warning.
> 
> Hi Hans.
> 
> It's not really fixable.  Of course you are welcome to
> try though.
> 
> Many patches are discrete and the entire series isn't
> visible to a single MAINTAINERS update scan by checkpatch.

I understand that in that scenario it is not fixable, but in the case I was
talking about the addition of the new file and the MAINTAINERS update
are part of a single patch (adding a small new driver), it would be nice
if at least in that case checkpatch would not complain. This does not even
need to be really smart, it could just check if a patch introducing new
files is touching MAINTAINERS at all, and if it does suppress the warning.

As said my perl-foo is weak, so I will not be trying to fix this myself.

Regards,

Hans

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaIHMn3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:43:29 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:60511 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290AbaIHMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:43:26 -0400
Message-ID: <540DA42D.3080208@gmail.com>
Date: Mon, 08 Sep 2014 13:42:21 +0100
From: Emil Velikov <emil.l.velikov@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Thomas Hellstrom <thellstrom@vmware.com>
CC: emil.l.velikov@gmail.com, dmarlin@redhat.com,
        Josh Boyer <jwboyer@fedoraproject.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, Brian Paul <brianp@vmware.com>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org> <540D9A9B.6070706@gmail.com> <540D9DC5.8010101@vmware.com>
In-Reply-To: <540D9DC5.8010101@vmware.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/14 13:15, Thomas Hellstrom wrote:
> Hi!
> 
> On 09/08/2014 02:01 PM, Emil Velikov wrote:
[snip]
>>
>> To the VMware guys,
>>
>> Any objections if we update the libdrm header and drop the mesa/ddx copies ?
>>
>> Cheers,
>> Emil
> Hi!
> 
> vmwgfx libdrm is pretty obsolete and AFAIK not used by anyone.
> As such, it's unnecessary to release a new version of libdrm each time
> the vmwgfx header is updated, and I'd like to avoid that dependency.
> Better to keep the local copies in the gallium winsys and the DDX. Since
> the ioctl interface is backwards compatible, it doesn't really matter if
> the headers are slightly out of sync.
> 
Afaict libdrm releases are dirt cheap, and should not cause any issues. Yet
it's your code so you'll be the judge of it all.

I'm just a de-duplication fanatic :)

-Emil


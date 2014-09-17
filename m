Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772AbaIQADl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 20:03:41 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:42180 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752935AbaIQADk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 20:03:40 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA5t5Q3gRPaHebM7npfKLpET7xm70DXDWMbV0L0nsviBvQ@mail.gmail.com>
References: <20140905171959.GO5216@hansolo.jdub.homelinux.org>
	<CA+5PVA5t5Q3gRPaHebM7npfKLpET7xm70DXDWMbV0L0nsviBvQ@mail.gmail.com>
Date: Wed, 17 Sep 2014 10:03:38 +1000
Message-ID: <CAPM=9tyonxiZgiSGaSc3XZoePP0TAXrtHFGtdpxdSf_=fmk3Qg@mail.gmail.com>
Subject: Re: [PATCH] drm/vmwgfx: Fix drm.h include
From: Dave Airlie <airlied@gmail.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Thomas Hellstrom <thellstrom@vmware.com>, David Airlie <airlied@linux.ie>,
        Brian Paul <brianp@vmware.com>, dmarlin@redhat.com,
        DRI mailing list <dri-devel@lists.freedesktop.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16 September 2014 23:43, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Fri, Sep 5, 2014 at 1:19 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>> The userspace drm.h include doesn't prefix the drm directory.  This can lead
>> to compile failures as /usr/include/drm/ isn't in the standard gcc include
>> paths.  Fix it to be <drm/drm.h>, which matches the rest of the driver drm
>> header files that get installed into /usr/include/drm.
>>
>> Red Hat Bugzilla: https://bugzilla.redhat.com/show_bug.cgi?id=1138759
>>
>> Fixes: 1d7a5cbf8f74e
>> Reported-by: Jeffrey Bastian <jbastian@redhat.com>
>> Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
>
> Ping?  Did this get queued anywhere?

Yes its in drm-next.

Dave.

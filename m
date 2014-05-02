Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752949AbaEBTzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 15:55:47 -0400
Received: from mail.tpi.com ([74.45.170.26]:49299 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbaEBTzq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 15:55:46 -0400
Message-ID: <5363F840.60304@canonical.com>
Date: Fri, 02 May 2014 13:55:44 -0600
From: Tim Gardner <tim.gardner@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Alex Deucher <alexdeucher@gmail.com>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        Maling list - DRI developers 
	<dri-devel@lists.freedesktop.org>,
        kernel-team <kernel-team@lists.ubuntu.com>,
        Dave Airlie <airlied@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: Lenovo x120e resume regression in 3.15-rc1 bisected to 'drm/crtc-helpers:
 fix dpms on logic'
References: <5363CA91.7070203@canonical.com> <CADnq5_OeiqpDZoPcAccKJn9Tvzz-euNJou4LhZqNKOH64F+7dw@mail.gmail.com> <5363E455.2020500@canonical.com>
In-Reply-To: <5363E455.2020500@canonical.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 12:30 PM, Tim Gardner wrote:
> On 05/02/2014 11:21 AM, Alex Deucher wrote:
>> On Fri, May 2, 2014 at 12:40 PM, Tim Gardner <tim.gardner@canonical.com> wrote:
>>> I've bisected a resume regression on a Lenovo x120e to
>>> 177cf92de4aa97ec1435987e91696ed8b5023130 (drm/crtc-helpers: fix dpms on
>>> logic). Everything works fine with this patch reverted on top of
>>> 3.15-rc3. I realize it is correcting a coding error that has been in
>>> place since 3.11, but it is also causing this laptop to resume to a
>>> black screen wherein the platform appears to be locked up (no console,
>>> no network). See attached bisect log and lspci. The BIOS version is 1.15.
>>>
>>
>> Does the attached patch help?  I haven't had a chance to unwind all
>> the logic in the crtc helper code.
>>
>> Alex
>>
> 
> Nope, same symptom. Black screen on resume, no network, etc.
> 
> rtg
> 

linux-next tip (20140502) appears to have the same bug.

rtg
-- 
Tim Gardner tim.gardner@canonical.com

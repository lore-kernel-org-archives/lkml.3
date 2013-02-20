Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935575Ab3BTNqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 08:46:44 -0500
Received: from mx02.infracom.it ([62.196.48.10]:28766 "EHLO mx02.infracom.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935309Ab3BTNqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 08:46:43 -0500
X-Greylist: delayed 329 seconds by postgrey-1.27 at vger.kernel.org; Wed, 20 Feb 2013 08:46:43 EST
Message-ID: <5124D276.4020802@infracom.it>
Date: Wed, 20 Feb 2013 14:41:10 +0100
From: Roberto Oppedisano <roberto.oppedisano@infracom.it>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Zhang Rui <rui.zhang@intel.com>
CC: Salvatore Sisinni <s.sisinni@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "eduardo.valentin@ti.com" <eduardo.valentin@ti.com>
Subject: Re: regression in linux 3.7 - fan speed at 100% after suspend/resume
 at 100%
References: <50BDF345.60804@gmail.com>  <1354630272.2480.4.camel@rzhang1-mobl4> <50BEF830.6020206@gmail.com>  <50D1CF9D.2090709@infracom.it>  <CADuOw61+kM6o-zK=7ZTZQSDU8-y-_NcmAaVJFnaSzNBXuqzggg@mail.gmail.com> <1361319657.2264.0.camel@rzhang1-mobl4>
In-Reply-To: <1361319657.2264.0.camel@rzhang1-mobl4>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Il 20/02/2013 01:20, Zhang Rui ha scritto:
> On Tue, 2013-02-19 at 18:54 +0100, Salvatore Sisinni wrote:
>> Hello Rui,
>>
>> same problem here with kernel-3.7.8-202.fc18.x86_64
>> but fan speed after resume with kernel-3.6.10-4.fc18.x86_64  seems ok
>> acpidump and sys/class/thermal/  details are attached
>>
> Hmmm,
> can you please check if the problem still exists in the -next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/rzhang/linux.git

I had a merge conflict resolved with a:

git rm drivers/thermal/exynos_thermal.c

(the file is unused with my config).

Anyway now I'm running on your next branch and the problem seems to be 
gone (I tried a couple of suspend resume cycles).

Kind regards
R

-- 
Roberto Oppedisano


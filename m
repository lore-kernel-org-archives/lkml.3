Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937016Ab3DJWAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:00:42 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:48100 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934226Ab3DJWAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:00:40 -0400
Message-ID: <5165E103.3020106@gmail.com>
Date: Thu, 11 Apr 2013 00:00:35 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: linux-next: Tree for Apr 10 (media and OF)
References: <20130410184852.92a3a02bbe5c3a040be76365@canb.auug.org.au> <5165DB54.90508@infradead.org>
In-Reply-To: <5165DB54.90508@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2013 11:36 PM, Randy Dunlap wrote:
> On 04/10/13 01:48, Stephen Rothwell wrote:
>> Hi all,
>>
>> Changes since 20130409:
>>
>
>
> on i386:
>
> ERROR: "of_get_next_parent" [drivers/media/v4l2-core/videodev.ko] undefined!
>
>
> 'of_get_next_parent()' should be exported for use by modules...?

Yes, there was already a patch submitted for this [1]. Hopefully it gets
picked soon so we don't see such errors. That's my oversight, sorry 
about it.

[1] http://www.spinics.net/lists/linux-media/msg61994.html

Thanks,
Sylwester

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab3ANRe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 12:34:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:55207 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376Ab3ANRe6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 12:34:58 -0500
Message-ID: <50F440F5.3030006@zytor.com>
Date: Mon, 14 Jan 2013 09:31:33 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Tang Chen <tangchen@cn.fujitsu.com>
CC: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        wency@cn.fujitsu.com, laijs@cn.fujitsu.com, linfeng@cn.fujitsu.com,
        yinghai@kernel.org, isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au,
        lliubbo@gmail.com, jaegeuk.hanse@gmail.com, tony.luck@intel.com,
        glommer@parallels.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH v5 0/5] Add movablecore_map boot option
References: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
In-Reply-To: <1358154925-21537-1-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 01:15 AM, Tang Chen wrote:
>
> For now, users can disable this functionality by not specifying the boot option.
> Later, we will post SRAT support, and add another option value "movablecore_map=acpi"
> to using SRAT.
>

I still think the option "movablecore_map" is uglier than hell.  "core" 
could just as easily refer to CPU cores there, but it is a memory mem. 
"movablemem" seems more appropriate.

Again, without SRAT I consider this patchset to be largely useless for 
anything other than prototyping work.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


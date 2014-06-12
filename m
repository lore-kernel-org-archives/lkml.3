Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaFLCet (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 22:34:49 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:17246 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754332AbaFLCer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 22:34:47 -0400
X-IronPort-AV: E=Sophos;i="5.00,692,1396972800"; 
   d="scan'208";a="31789910"
Message-ID: <539912E2.7010703@cn.fujitsu.com>
Date: Thu, 12 Jun 2014 10:39:30 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: <no@pd.tnic>, <To-header@pd.tnic>, <on@pd.tnic>, <input@pd.tnic>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, <linux-kernel@vger.kernel.org>,
        <dri-devel@lists.freedesktop.org>
Subject: Re: [RFC PATCH] nouveau: rename aux.c to auxiliary.c for reviewing
 it on Windows
References: <1402473247-30468-1-git-send-email-laijs@cn.fujitsu.com> <20140611082425.GA5859@pd.tnic>
In-Reply-To: <20140611082425.GA5859@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 04:24 PM, Borislav Petkov wrote:
> On Wed, Jun 11, 2014 at 03:53:55PM +0800, Lai Jiangshan wrote:
>> When I tried to review the linux kernel on Windows in my laptop
>> and incidentally found that it failed to open the aux.c.
>>
>> And Microsoft tells me:
>> (http://msdn.microsoft.com/en-us/library/aa365247.aspx)
>>
>>> Do not use the following reserved names for the name of a file:
>>> CON, PRN, AUX, NUL, <snip...>, and LPT9. Also avoid these names
>>> followed immediately by an extension; for example, NUL.txt
>>> is not recommended.
>>
>> The name "aux" is listed above. And it sometimes makes sense to
>> review linux on windows, so we rename the aux.c to auxiliary.c.
> 
> I think you missed April 1st by more than 2 months.
> 

EVERY DAY IS APRIL FIRST if you fool others' convenience.

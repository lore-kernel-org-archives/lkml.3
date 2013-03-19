Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934351Ab3CSXio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 19:38:44 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:50373 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757276Ab3CSXin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:38:43 -0400
Message-ID: <5148F565.7060809@gmail.com>
Date: Wed, 20 Mar 2013 07:31:49 +0800
From: Ric Mason <ric.masonn@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: konrad@darnok.org
CC: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] introduce zero-filled page stat count
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com> <1363255697-19674-4-git-send-email-liwanp@linux.vnet.ibm.com> <20130316130638.GB5987@konrad-lan.dumpdata.com> <5145BE06.8070309@gmail.com> <CAPbh3rvzuScPorS8Nc0Er33gYrbYNc9cqfPbN2Ca7QkhVSN9hA@mail.gmail.com>
In-Reply-To: <CAPbh3rvzuScPorS8Nc0Er33gYrbYNc9cqfPbN2Ca7QkhVSN9hA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2013 12:41 AM, Konrad Rzeszutek Wilk wrote:
> On Sun, Mar 17, 2013 at 8:58 AM, Ric Mason <ric.masonn@gmail.com> wrote:
>> Hi Konrad,
>>
>> On 03/16/2013 09:06 PM, Konrad Rzeszutek Wilk wrote:
>>> On Thu, Mar 14, 2013 at 06:08:16PM +0800, Wanpeng Li wrote:
>>>> Introduce zero-filled page statistics to monitor the number of
>>>> zero-filled pages.
>>> Hm, you must be using an older version of the driver. Please
>>> rebase it against Greg KH's staging tree. This is where most if not
>>> all of the DebugFS counters got moved to a different file.
>>
>> It seems that zcache debugfs in Greg's staging-next is buggy, Could you test
>> it?
>>
> Could you email me what the issue you are seeing?
They have already fixed in Wanpeng's patchset v4.

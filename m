Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151Ab3CSQlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:41:53 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:43236 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756996Ab3CSQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:41:51 -0400
MIME-Version: 1.0
Reply-To: konrad@darnok.org
In-Reply-To: <5145BE06.8070309@gmail.com>
References: <1363255697-19674-1-git-send-email-liwanp@linux.vnet.ibm.com>
	<1363255697-19674-4-git-send-email-liwanp@linux.vnet.ibm.com>
	<20130316130638.GB5987@konrad-lan.dumpdata.com>
	<5145BE06.8070309@gmail.com>
Date: Tue, 19 Mar 2013 12:41:49 -0400
X-Google-Sender-Auth: AK_xzE0rjFa2qWGz9zVputyTneM
Message-ID: <CAPbh3rvzuScPorS8Nc0Er33gYrbYNc9cqfPbN2Ca7QkhVSN9hA@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] introduce zero-filled page stat count
From: Konrad Rzeszutek Wilk <konrad@darnok.org>
To: Ric Mason <ric.masonn@gmail.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Minchan Kim <minchan@kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 8:58 AM, Ric Mason <ric.masonn@gmail.com> wrote:
> Hi Konrad,
>
> On 03/16/2013 09:06 PM, Konrad Rzeszutek Wilk wrote:
>>
>> On Thu, Mar 14, 2013 at 06:08:16PM +0800, Wanpeng Li wrote:
>>>
>>> Introduce zero-filled page statistics to monitor the number of
>>> zero-filled pages.
>>
>> Hm, you must be using an older version of the driver. Please
>> rebase it against Greg KH's staging tree. This is where most if not
>> all of the DebugFS counters got moved to a different file.
>
>
> It seems that zcache debugfs in Greg's staging-next is buggy, Could you test
> it?
>
Could you email me what the issue you are seeing?

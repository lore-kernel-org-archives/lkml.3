Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697AbaJPHYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:24:13 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:24620 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671AbaJPHYL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:24:11 -0400
Message-ID: <543F7289.8010807@huawei.com>
Date: Thu, 16 Oct 2014 15:23:53 +0800
From: Weng Meiling <wengmeiling.weng@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Frans Klaver <fransklaver@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, <akpm@linux-foundation.org>,
        <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
References: <543E1754.8040701@huawei.com>	<543F25D3.8010708@huawei.com> <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
In-Reply-To: <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.24.66]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020202.543F7298.010B,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: d62fd44aa0b65d0dd98eecb70c94d65c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/16 15:07, Frans Klaver wrote:
> On Thu, Oct 16, 2014 at 3:56 AM, Weng Meiling
> <wengmeiling.weng@huawei.com> wrote:
>>
>> Would you please give me some of your views on this issue? Any suggestion is appreciative.
> 
> It'll come. Be patient.
> 
> .
> 
yeah, maybe I'm too impatient :). But this is important for me.
Thanks for your reply.


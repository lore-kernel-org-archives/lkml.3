Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752314AbaJPJOf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 05:14:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41753 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaJPJOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 05:14:33 -0400
Date: Thu, 16 Oct 2014 11:13:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Weng Meiling <wengmeiling.weng@huawei.com>
Cc: Frans Klaver <fransklaver@gmail.com>, tj@kernel.org,
        Jens Axboe <axboe@kernel.dk>, akpm@linux-foundation.org,
        adilger.kernel@dilger.ca, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiang Rui <rui.xiang@huawei.com>, Li Zefan <lizefan@huawei.com>,
        Huang Qiang <h.huangqiang@huawei.com>,
        Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: Re: Subject: [PATCH] kobject: fix the race between kobject_del and
 get_device_parent
Message-ID: <20141016091328.GB24374@kroah.com>
References: <543E1754.8040701@huawei.com>
 <543F25D3.8010708@huawei.com>
 <CAH6sp9PZYLRntXzmX14OmJpwWBu2_h=_h3oSvpaHE=gAG0meBw@mail.gmail.com>
 <543F7289.8010807@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <543F7289.8010807@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 16, 2014 at 03:23:53PM +0800, Weng Meiling wrote:
> On 2014/10/16 15:07, Frans Klaver wrote:
> > On Thu, Oct 16, 2014 at 3:56 AM, Weng Meiling
> > <wengmeiling.weng@huawei.com> wrote:
> >>
> >> Would you please give me some of your views on this issue? Any suggestion is appreciative.
> > 
> > It'll come. Be patient.
> > 
> > .
> > 
> yeah, maybe I'm too impatient :)

*plonk*

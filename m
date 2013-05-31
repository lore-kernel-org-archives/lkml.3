Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab3EaEb0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 00:31:26 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45092 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873Ab3EaEbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 00:31:20 -0400
Message-ID: <51A82793.4080204@gmail.com>
Date: Fri, 31 May 2013 12:31:15 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Jiang Liu <jiang.liu@huawei.com>, David Rientjes <rientjes@google.com>,
        Wen Congyang <wency@cn.fujitsu.com>, Mel Gorman <mgorman@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        David Howells <dhowells@redhat.com>, Mark Salter <msalter@redhat.com>,
        Jianguo Wu <wujianguo@huawei.com>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Florian Tobias Schandinat <florianschandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH v8, part3 06/14] mm, acornfb: use free_reserved_area()
 to simplify code
References: <1369575522-26405-1-git-send-email-jiang.liu@huawei.com> <1369575522-26405-7-git-send-email-jiang.liu@huawei.com> <20130530145844.902b3a947c1f7430c1c2ecf5@linux-foundation.org>
In-Reply-To: <20130530145844.902b3a947c1f7430c1c2ecf5@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 31 May 2013 05:58:44 AM CST, Andrew Morton wrote:
> On Sun, 26 May 2013 21:38:34 +0800 Jiang Liu <liuj97@gmail.com> wrote:
>
>> Use common help function free_reserved_area() to simplify code.
>
> http://ozlabs.org/~akpm/mmots/broken-out/drivers-video-acornfbc-remove-dead-code.patch
> removes all the code which your patch alters.
Thanks Andrew, please just drop that patch.


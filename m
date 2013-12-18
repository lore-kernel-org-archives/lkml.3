Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab3LRBir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 20:38:47 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:27585 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936Ab3LRBio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 20:38:44 -0500
Message-ID: <52B0F9CB.5010508@huawei.com>
Date: Wed, 18 Dec 2013 09:26:35 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Li Wang <liwang@ubuntukylin.com>
CC: Matthew Wilcox <matthew@wil.cx>, Cong Wang <xiyou.wangcong@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Sage Weil <sage@inktank.com>,
        <linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Yunchuan Wen <yunchuanwen@ubuntukylin.com>
Subject: Re: [PATCH 0/5] VFS: Directory level cache cleaning
References: <cover.1387205337.git.liwang@ubuntukylin.com> <CAM_iQpUSX1yX9SMvUnbwZ7UkaBMUheOEiZNaSb4m8gWBQzzGDQ@mail.gmail.com> <52AFC020.10403@ubuntukylin.com> <20131217035847.GA10392@parisc-linux.org> <52AFFBE3.8020507@ubuntukylin.com> <52B01594.80001@huawei.com> <52B019F5.7020505@ubuntukylin.com>
In-Reply-To: <52B019F5.7020505@ubuntukylin.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/12/17 17:31, Li Wang wrote:
> This extension is just add-on extension. The original debugging
> capability is still there, and more flexible debugging is now allowed.
> 

but you intent is to let applications use this interface for
non-debugging purpose.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965653Ab3DQBxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 21:53:31 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:36970 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935382Ab3DQBx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 21:53:29 -0400
Message-ID: <516E007D.1070608@huawei.com>
Date: Wed, 17 Apr 2013 09:53:01 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Howells <dhowells@redhat.com>
CC: <linux-kernel@vger.kernel.org>, <containers@lists.linux-foundation.org>,
        Tejun Heo <tj@kernel.org>, <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, <cgroups@vger.kernel.org>
Subject: Re: [PATCH 25/28] proc: Supply an accessor to get the process ID
 associated with some proc files [RFC]
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk> <20130416182730.27773.88726.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130416182730.27773.88726.stgit@warthog.procyon.org.uk>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/4/17 2:27, David Howells wrote:
> Supply an accessor to get the process ID associated with some proc files and
> directories (get_proc_pid()).
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Tejun Heo <tj@kernel.org>
> cc: Li Zefan <lizefan@huawei.com>
> cc: containers@lists.linux-foundation.org
> cc: cgroups@vger.kernel.org

Acked-by: Li Zefan <lizefan@huawei.com>


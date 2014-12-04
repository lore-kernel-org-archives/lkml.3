Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633AbaLDQ2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:28:35 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:37922 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932236AbaLDQ2d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:28:33 -0500
Message-ID: <1417710508.2239.14.camel@linaro.org>
Subject: Re: [PATCH v12 6/7] kprobes: Pass the original kprobe for preparing
 optimized kprobe
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 04 Dec 2014 16:28:28 +0000
In-Reply-To: <1417671350-53346-1-git-send-email-wangnan0@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
	 <1417671350-53346-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-12-04 at 13:35 +0800, Wang Nan wrote:
> From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Pass the original kprobe for preparing an optimized kprobe arch-dep
> part, since for some architecture (e.g. ARM32) requires the information
> in original kprobe.
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Wang Nan <wangnan0@huawei.com>

Seems strange cc'ing yourself :-) That should be Signed-off-by instead,
as you're the person sending out the patch.

[rest of patch trimmed]

-- 
Tixy


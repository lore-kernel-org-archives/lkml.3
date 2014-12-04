Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932606AbaLDQW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:22:58 -0500
Received: from queue01a.mail.zen.net.uk ([212.23.3.234]:55270 "EHLO
	queue01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753665AbaLDQW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:22:57 -0500
Message-ID: <1417710139.2239.12.camel@linaro.org>
Subject: Re: [PATCH v12 5/7] ARM: kprobes: Add test cases for stack
 consuming instructions
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 04 Dec 2014 16:22:19 +0000
In-Reply-To: <1417671341-53297-1-git-send-email-wangnan0@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
	 <1417671341-53297-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the source file reorg caused the author of this patch to
change. It should be...

From: Jon Medhurst <tixy@linaro.org>

On Thu, 2014-12-04 at 13:35 +0800, Wang Nan wrote:
> These have extra 'checker' functions associated with them so
> lets make sure those get covered by testing.
> 
> Signed-off-by: Jon Medhurst <tixy@linaro.org>
> Signed-off-by: Wang Nan <wangnan0@huawei.com>
> 
>

[rest of patch trimmed]


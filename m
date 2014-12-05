Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbaLEKsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 05:48:42 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:49404 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750934AbaLEKsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 05:48:41 -0500
Message-ID: <1417776515.2232.3.camel@linaro.org>
Subject: Re: [PATCH v12 7/7] ARM: kprobes: enable OPTPROBES for ARM 32
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>
Cc: masami.hiramatsu.pt@hitachi.com, linux@arm.linux.org.uk,
        lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Fri, 05 Dec 2014 10:48:35 +0000
In-Reply-To: <548189D4.3010907@huawei.com>
References: <1417671172-52915-1-git-send-email-wangnan0@huawei.com>
			 <1417671360-53399-1-git-send-email-wangnan0@huawei.com>
		 <1417710073.2239.10.camel@linaro.org> <5481289E.4060504@huawei.com>
	 <1417774227.2232.1.camel@linaro.org> <548189D4.3010907@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 18:32 +0800, Wang Nan wrote:
> Both your and mine failure are related to ldrd/h instruction. What
> about your second failed testcase?

Can't remember exactly, but it was some instruction that didn't access
memory I remember that much.

I've also just run the tests on an A9 CPU and get the Oops on the nop
after the 'wfi' instruction test. So looks like the problem isn't
related to particular test cases.

-- 
Tixy


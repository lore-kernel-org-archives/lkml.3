Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbbALSVh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:21:37 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:57985 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751881AbbALSVg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:21:36 -0500
Message-ID: <1421086886.18443.23.camel@linaro.org>
Subject: What's the correct tree to route kprobes patches through?
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, Wang Nan <wangnan0@huawei.com>
Date: Mon, 12 Jan 2015 18:21:26 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All

I'm wondering what the correct route is for getting kprobes patches into
mainline Linux. In particular I'm interested in a patch from Masami
Hiramatsu [1] which is a dependency for some ARM kprobes work we want to
merge. If acceptable, we could submit that one though the ARM
maintainer's tree with our other work.

[1] http://marc.info/?l=linux-kernel&m=142045769001242&w=2
    (kprobes: Pass the original kprobe for preparing optimized kprobe)

Thanks

-- 
Tixy


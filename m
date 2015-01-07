Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271AbbAGNkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:40:23 -0500
Received: from smarthost01a.mail.zen.net.uk ([212.23.1.1]:48573 "EHLO
	smarthost01a.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753114AbbAGNkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:40:22 -0500
Message-ID: <1420638014.4044.52.camel@linaro.org>
Subject: Re: [PATCH v19 00/11] ARM: kprobes: OPTPROBES and other
 improvements.
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Wang Nan <wangnan0@huawei.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: linux@arm.linux.org.uk, lizefan@huawei.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Date: Wed, 07 Jan 2015 13:40:14 +0000
In-Reply-To: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01a-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think that the patches up to 09/11 inclusive have been though more
that enough review and revisions to think about getting them merged,
there doesn't seem much point in continuously resending them whilst new
features are built on top of them.

Masami Hiramatsu, are you happy for your patch to generic+X86 kprobes
code [1] to go through the ARM maintainers tree, assuming Russell is
also happy with that. Or should that go via a different route?

[1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/313218.html

Wang Nan, assuming everyone is happy, can you put together a branch in a
git repository for those patches, or I'm more than happy to do that if
you like. Then I can give the series a final test and we can send a pull
request to Russell King.

Thanks all

-- 
Tixy


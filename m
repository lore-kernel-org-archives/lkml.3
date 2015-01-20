Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448AbbATCRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 21:17:48 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:49793 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752356AbbATCRr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 21:17:47 -0500
Message-ID: <54BDBAC4.5040003@hitachi.com>
Date: Tue, 20 Jan 2015 11:17:40 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: "Jon Medhurst (Tixy)" <tixy@linaro.org>
Cc: Wang Nan <wangnan0@huawei.com>, linux@arm.linux.org.uk, lizefan@huawei.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Re: [PATCH v19 00/11] ARM: kprobes: OPTPROBES and other improvements.
References: <1420457284-76923-1-git-send-email-wangnan0@huawei.com> <1420638014.4044.52.camel@linaro.org>
In-Reply-To: <1420638014.4044.52.camel@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2015/01/07 22:40), Jon Medhurst (Tixy) wrote:
> I think that the patches up to 09/11 inclusive have been though more
> that enough review and revisions to think about getting them merged,
> there doesn't seem much point in continuously resending them whilst new
> features are built on top of them.
> 
> Masami Hiramatsu, are you happy for your patch to generic+X86 kprobes
> code [1] to go through the ARM maintainers tree, assuming Russell is
> also happy with that. Or should that go via a different route?

Yes, I'm OK to go it through the ARM maintainers tree :)

Thank you,

> 
> [1] http://lists.infradead.org/pipermail/linux-arm-kernel/2015-January/313218.html
> 
> Wang Nan, assuming everyone is happy, can you put together a branch in a
> git repository for those patches, or I'm more than happy to do that if
> you like. Then I can give the series a final test and we can send a pull
> request to Russell King.
> 
> Thanks all
> 


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Research Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com



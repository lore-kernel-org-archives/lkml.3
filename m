Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865AbaD1JzO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 05:55:14 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:50513 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaD1JzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 05:55:12 -0400
Message-ID: <535E2578.1010103@linaro.org>
Date: Mon, 28 Apr 2014 18:55:04 +0900
From: AKASHI Takahiro <takahiro.akashi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "rgb@redhat.com" <rgb@redhat.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "dsaxena@linaro.org" <dsaxena@linaro.org>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>
Subject: Re: [PATCH_v8 2/2] arm64: audit: Add audit hook in syscall_trace_enter/exit()
References: <1394705767-12423-1-git-send-email-takahiro.akashi@linaro.org> <1394862548-29060-1-git-send-email-takahiro.akashi@linaro.org> <1394862548-29060-3-git-send-email-takahiro.akashi@linaro.org> <20140416113002.GG29754@arm.com>
In-Reply-To: <20140416113002.GG29754@arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/16/2014 08:30 PM, Will Deacon wrote:
> On Sat, Mar 15, 2014 at 05:49:08AM +0000, AKASHI Takahiro wrote:
>> This patch adds auditing functions on entry to or exit from
>> every system call invocation.
>>
>> Acked-by: Richard Guy Briggs <rgb@redhat.com>
>> Signed-off-by: AKASHI Takahiro <takahiro.akashi@linaro.org>
>
> I think I already acked this patch.

Oh, yeah? Thanks.
-Takahiro AKASHI

> Will
>

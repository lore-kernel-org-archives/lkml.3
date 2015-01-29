Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762238AbbA2KZd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 05:25:33 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:43423 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762219AbbA2KZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 05:25:30 -0500
Message-ID: <54CA0A96.1090007@cogentembedded.com>
Date: Thu, 29 Jan 2015 13:25:26 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Peter Hung <hpeter@gmail.com>, johan@kernel.org
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom_tsai@fintek.com.tw,
        peter_hong@fintek.com.tw, Peter Hung <hpeter+linux_kernel@gmail.com>
Subject: Re: [PATCH v3 5/5] usb: serial: implement CMSPAR for F81232
References: <1422424712-7561-1-git-send-email-hpeter+linux_kernel@gmail.com> <54C8D68B.6010607@cogentembedded.com> <54C9946D.508@gmail.com>
In-Reply-To: <54C9946D.508@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 1/29/2015 5:01 AM, Peter Hung wrote:

> Hello.

     Please don't top-post.

> I had using "scripts/checkpatch.pl -f" to scan original f81232.c.
> It reported with "quoted string split across lines", so I merge these
> 2 strings into 1 in patch 1/5.

    Seems like another unrelated change...

> But it still warning with "line over 80
> character", so I had shorted string with this line.

    Hm, the modern checkpatch.pl shouldn't warn about long lines due to string 
literals used in dev_err(), etc. calls.

> I will refine my patch set again with more attention.

    In any case, don't leave the warnings till some next patch, fix them at once.

> Thanks for your advice.

WBR, Sergei


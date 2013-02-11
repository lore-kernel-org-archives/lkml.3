Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab3BKQ5H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 11:57:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37508 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757893Ab3BKQ5F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 11:57:05 -0500
Message-ID: <511922A5.4020208@zytor.com>
Date: Mon, 11 Feb 2013 08:56:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH 0/4 -v3]  x86, head_32: Some cleanups
References: <1360592538-10643-1-git-send-email-bp@alien8.de>
In-Reply-To: <1360592538-10643-1-git-send-email-bp@alien8.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 06:22 AM, Borislav Petkov wrote:
> From: Borislav Petkov <bp@suse.de>
>
> Hi,
>
> this is the new version with patch 5 from the old transformed into an
> expanded, more verbose comment at the beginning of default_entry. No
> changes otherwise.
>

By the way, I like the series.  I do think we should try to keep the 
current "best effort" support for hetero systems (they do happen, I see 
them every now and then in the field), but other than that this is a 
nice cleanup.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


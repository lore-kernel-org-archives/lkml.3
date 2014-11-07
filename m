Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751912AbaKGLxL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:53:11 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:65276 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281AbaKGLxI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:53:08 -0500
Message-ID: <545CB2A0.8050504@nod.at>
Date: Fri, 07 Nov 2014 12:53:04 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] UBI: Fix double free after do_sync_erase()
References: <1415288869-14915-1-git-send-email-richard@nod.at> <1415361043.958.326.camel@sauron.fi.intel.com>
In-Reply-To: <1415361043.958.326.camel@sauron.fi.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 07.11.2014 um 12:50 schrieb Artem Bityutskiy:
> On Thu, 2014-11-06 at 16:47 +0100, Richard Weinberger wrote:
>> If the erase worker is unable to erase a PEB it will
>> free the ubi_wl_entry itself.
>> The failing ubi_wl_entry must not free()'d again after
>> do_sync_erase() returns.
>>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
> 
> Pushed, thanks!

BTW: Please don't forget "[PATCH] UBI: Fix invalid vfree()".

Thanks,
//richard

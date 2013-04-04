Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab3DDFVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 01:21:04 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39144 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711Ab3DDFVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 01:21:03 -0400
Message-ID: <515D0DB7.7000001@gmail.com>
Date: Thu, 04 Apr 2013 13:20:55 +0800
From: Simon Jeons <simon.jeons@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com> <515CD359.40004@gmail.com> <515CD3BF.5010104@zytor.com> <515CD4A7.6070903@gmail.com> <515CD81D.6020603@zytor.com>
In-Reply-To: <515CD81D.6020603@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi H.Peter,
On 04/04/2013 09:32 AM, H. Peter Anvin wrote:
> On 04/03/2013 06:17 PM, Simon Jeons wrote:
>> e820 also contain mmio, correct?
> No.

How to check which address is used by mmio? /proc/iomem, correct?

>
>> So cpu should not access address beyond
>> e820 map(RAM+MMIO).
> No.
>
> 	-hpa
>
>


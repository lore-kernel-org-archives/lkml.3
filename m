Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932915Ab3DDCPW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:15:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46201 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932826Ab3DDCPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:15:19 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <515CDD0A.8040100@gmail.com>
References: <1364905733-23937-1-git-send-email-fhrbata@redhat.com> <515B2802.1050405@zytor.com> <515CD359.40004@gmail.com> <515CD3BF.5010104@zytor.com> <515CD4A7.6070903@gmail.com> <515CD81D.6020603@zytor.com> <515CDD0A.8040100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] x86: add phys addr validity check for /dev/mem mmap
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Wed, 03 Apr 2013 19:14:55 -0700
To: Simon Jeons <simon.jeons@gmail.com>
CC: Frantisek Hrbata <fhrbata@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, oleg@redhat.com, kamaleshb@in.ibm.com,
        hechjie@cn.ibm.com
Message-ID: <6158c206-0861-41c9-84b8-6fec82b8110d@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Because git didn't exist before then?

Simon Jeons <simon.jeons@gmail.com> wrote:

>On 04/04/2013 09:32 AM, H. Peter Anvin wrote:
>> On 04/03/2013 06:17 PM, Simon Jeons wrote:
>>> e820 also contain mmio, correct?
>> No.
>>
>>> So cpu should not access address beyond
>>> e820 map(RAM+MMIO).
>> No.
>>
>> 	-hpa
>>
>>
>
>One offline question, why can't check git log before 2005?

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.

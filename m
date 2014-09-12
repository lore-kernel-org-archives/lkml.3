Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003AbaILEo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 00:44:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48090 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751874AbaILEo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 00:44:28 -0400
Message-ID: <54127A16.4030701@zytor.com>
Date: Thu, 11 Sep 2014 21:44:06 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Dave Hansen <dave.hansen@intel.com>, Qiaowei Ren <qiaowei.ren@intel.com>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 07/10] x86, mpx: decode MPX instruction to get bound
 violation information
References: <1410425210-24789-1-git-send-email-qiaowei.ren@intel.com> <1410425210-24789-8-git-send-email-qiaowei.ren@intel.com> <alpine.DEB.2.10.1409120015030.4178@nanos> <5412230A.6090805@intel.com> <541223B1.5040705@zytor.com> <alpine.DEB.2.10.1409120133330.4178@nanos>
In-Reply-To: <alpine.DEB.2.10.1409120133330.4178@nanos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2014 04:37 PM, Thomas Gleixner wrote:
>>
>> Specifically because marshaling the data in and out of the generic
>> decoder was more complex than a special-purpose decoder.
>
> I did not look at that detail and I trust your judgement here, but
> that is in no way explained in the changelog.
>
> This whole patchset is a pain to review due to half baken changelogs
> and complete lack of a proper design description.
>

I'm not wedded to that concept, by the way, but using the generic parser 
had a whole bunch of its own problems, including the fact that you're 
getting bytes from user space.

It might be worthwhile to compare the older patchset which did use the 
generic parser to make sure that it actually made sense.

	-hpa





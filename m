Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753123Ab3LJT0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 14:26:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:51319 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690Ab3LJT0i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 14:26:38 -0500
Message-ID: <52A76AD5.40602@zytor.com>
Date: Tue, 10 Dec 2013 11:26:13 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Binutils <binutils@sourceware.org>, Jiri Kosina <jkosina@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>, Josh Boyer <jwboyer@redhat.com>
Subject: Re: RFC: binutils PATCH: Set e_type to ET_EXEC for -pie -Ttext-segment=
References: <CAMe9rOrKGSxr9X5txGq2Js0vGwXdwxPT+ip70-YZs-Wz-aPgQg@mail.gmail.com>	<52A766A4.7040202@zytor.com> <CAMe9rOoU51t9KUYEYFCVZVwDLTuGWyd9_d97-pcsFrT_WcYS0w@mail.gmail.com>
In-Reply-To: <CAMe9rOoU51t9KUYEYFCVZVwDLTuGWyd9_d97-pcsFrT_WcYS0w@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 11:15 AM, H.J. Lu wrote:
>>
>> Either way, if the *only* goal is to get the file above a certain point,
>> like 4 GiB, then there is no reason not to randomize upward.
> 
> I agree that kernel should load ET_DYN binary anywhere.  I will
> change linker to set type to ET_EXEC if p_vaddr != 0.
> 

I didn't say "anywhere".  I said "at or above the p_vaddr".

	-hpa


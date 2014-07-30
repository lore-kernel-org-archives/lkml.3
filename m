Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755535AbaG3RW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 13:22:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46857 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbaG3RWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 13:22:25 -0400
Message-ID: <53D92996.1050906@zytor.com>
Date: Wed, 30 Jul 2014 10:21:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@infradead.org>, Prarit Bhargava <prarit@redhat.com>,
        Matt Fleming <matt@console-pimps.org>
CC: Colin Ian King <colin.king@canonical.com>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org, lszubowi@redhat.com,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
References: <1406653761-3884-1-git-send-email-prarit@redhat.com> <20140729222932.GA17481@pd.tnic> <20140730144803.GB15082@console-pimps.org> <53D909C3.9050205@canonical.com> <53D9259F.5050307@redhat.com> <53D92700.3040803@infradead.org>
In-Reply-To: <53D92700.3040803@infradead.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2014 10:10 AM, Randy Dunlap wrote:
>>
>> My issue is simply that I'd like to know *exactly* how big each range is and not
>> have it rounded off.  Others think that it is easier to read Mib & Gib ...
> 
> It is easier to read in MiB or GiB IMHO, but since it is debug info,
> exact is good.  It would be even better [more readable] to use commas
> (or periods/dots) to separate it into groups of 3 digits.
> 

Arguably the exactness is available in the range...

	-hpa


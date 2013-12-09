Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933137Ab3LIVyJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 16:54:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37083 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933065Ab3LIVyF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 16:54:05 -0500
Message-ID: <52A63BF3.1000608@zytor.com>
Date: Mon, 09 Dec 2013 13:53:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>
CC: Jiri Kosina <jkosina@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Subject: Re: [PATCH] binfmt_elf: fix PIE load with randomization disabled
References: <CAMe9rOo9sUQiusm8u=eFDnxYz37Cczd+97M9in=P2mNWXpH5pQ@mail.gmail.com>	<alpine.LNX.2.00.1312092154350.24835@pobox.suse.cz>	<CAMe9rOr06QeTGe4OC5_JYtfdziYj8NsRgS5=arEJY3BTqeLMVg@mail.gmail.com>	<alpine.LNX.2.00.1312092210280.24835@pobox.suse.cz>	<CAMe9rOrDmtHXZ1cA1or_XkktSPguDnH8sNLGM_oxj7bcsek4ww@mail.gmail.com>	<52A63AD4.2030101@zytor.com> <CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
In-Reply-To: <CAMe9rOqEO271PUUkPAQu5hnZFyTX2viUXg8R0hpwDky0B-seyg@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 01:52 PM, H.J. Lu wrote:
>>
>> Why is that?  It would seem to be a big difference between a relocatable
>> binary (PIE) and one with a load address fixed at link time.
>>
> 
> PIE with non-zero vaddr should be loaded at non-zero
> vaddr.  Otherwise, PIE may not work as expected.
> 

Please explain why that is the case, as it seems to be implying that PIE
isn't actually relocatable in that case...

	-hpa



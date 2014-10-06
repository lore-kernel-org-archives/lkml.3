Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067AbaJFROe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 13:14:34 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:39685 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbaJFROb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 13:14:31 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-31-5432cdf3f18e
Message-id: <5432CDF1.5050904@samsung.com>
Date: Mon, 06 Oct 2014 20:14:25 +0300
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, rusty@rustcorp.com.au,
        keyrings@linux-nfs.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Subject: Re: [PATCH 3/4] module: search the key only by keyid
References: <542E9FE8.2070009@samsung.com>
 <6d32cecfb3c3f5d041900ce1866bc15134832991.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <cover.1412327306.git.d.kasatkin@samsung.com>
 <29146.1412340378@warthog.procyon.org.uk> <542E9B68.1010906@samsung.com>
 <542E9C65.4030208@samsung.com> <13201.1412343605@warthog.procyon.org.uk>
 <alpine.LRH.2.11.1410062344070.24016@namei.org>
In-reply-to: <alpine.LRH.2.11.1410062344070.24016@namei.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Originating-IP: [106.122.1.121]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOLMWRmVeSWpSXmKPExsVy+t/xq7qfzxqFGDR2mVi8a/rNYvFlaZ3F
	uvWLmSxm73rIYvFyxjx2i8u75rBZfOh5xGZxc9oFFotPKyYxO3B67Jx1l91j2ollLB4PDm1m
	8di94DOTR8/3ZI/3+66yeazYcILZ4/MmuQCOKC6blNSczLLUIn27BK6MjuUX2QuusVcceHWT
	vYGxi62LkZNDQsBE4vjr9ewQtpjEhXvrgeJcHEICSxkl3kz9CJYQEmhkkpi1WRAiMYtR4mzH
	e8YuRg4OXgEtiYZ7jCA1LAKqEqfO/GUGsdkE9CQ2NP8A6xUViJA4eXcPmM0rICjxY/I9FhBb
	RMBTYt6hCWBHMAtcY5ToWG4DYgsL2Eo86ToIcwSzxLfTM8EaOAVsJP6+uc8GspcZaMH9i1oQ
	vfISm9e8ZYa4U1Wie+1aqMcUJU5PPsc8gVF4FpLVsxC6ZyHpXsDIvIpRNLU0uaA4KT3XSK84
	Mbe4NC9dLzk/dxMjJLK+7mBceszqEKMAB6MSD2/kDsMQIdbEsuLK3EOMEhzMSiK85vOMQoR4
	UxIrq1KL8uOLSnNSiw8xMnFwSjUwlvB+OaeU+zDcWDJNcIf2oZf3v6Z3r2Us9WL8yedY2TTT
	+fj3pawt/gpOOXJsYWv33Qv7/Tmw1qj4eZH8Nf6IqFJJc3WTl+YfPjx7YKs7ZVt5XEnzMSut
	sJXddj9ZDVVNzPg0K5R/Gn249GH+ha439vtO/Sh6EHHtWODyi0dltsiZPD7679B3JZbijERD
	Leai4kQAOrZ0DYoCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 15:44, James Morris wrote:
> On Fri, 3 Oct 2014, David Howells wrote:
>
>> Dmitry Kasatkin <d.kasatkin@samsung.com> wrote:
>>
>>> BTW. But actually why signer is needed to find the key?
>>> Every key has unique fingerprint.
>> The SKID is by no means guaranteed unique, is not mandatory and has no defined
>> algorithm for generating it.
>>
>>> Or you say that different certificates might have the same PK?
>>> What I would consider strange. But anyway, if PK is the same, then
>>> verification succeed.
>> Do note: We *do* need to get away from using SKIDs.  We have situations where
>> we have to use a key that doesn't have one.
>>
> David, I need to push to Linus for 3.17 -- please finalize the fix for 
> this and send me a pull request.
>
>
>

Hi David,

I tested KEYS fixes and it works well for modules and integrity.

http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-next-fixes

Thanks!

- Dmitry


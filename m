Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3HGDks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 23:40:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45786 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756979Ab3HGDkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 23:40:46 -0400
Message-ID: <5201C18D.2030907@zytor.com>
Date: Tue, 06 Aug 2013 20:39:57 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Anders Larsen <al@alarsen.net>, Bjorn Helgaas <bhelgaas@google.com>,
        Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org, Konstantin Ryabitsev <mricon@kernel.org>
Subject: Re: kernel mailing list permalinks
References: <1375826105.22552.0@oscar> <5201813F.1070102@zytor.com> <1375830937.2424.41.camel@joe-AO722>
In-Reply-To: <1375830937.2424.41.camel@joe-AO722>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 04:15 PM, Joe Perches wrote:
> On Tue, 2013-08-06 at 16:05 -0700, H. Peter Anvin wrote:
>> On 08/06/2013 02:55 PM, Anders Larsen wrote:
>>> On 2013-08-06 23:23, H. Peter Anvin wrote:
>>>> On 08/06/2013 02:11 PM, Bjorn Helgaas wrote:
>>>>>>
>>>>>> The above link is also a good example of subtleness: + in a URL
>>>> means a
>>>>>> space character, it has to be escaped as %2B.  Particularly a
>>>> problem in
>>>>>> gmail message-ids.
>>>
>>> the link in question works just fine without escaping the +; the + only
>>> has to be escaped in then query component of a URL, not in the path
>>> component where it is just another valid character - and the link in
>>> question did not contain any query component.
>>>
>>> (see RFC 3986 sections 3.3 and 3.4)
> 
> Rather than relying on third party links,
> it'd be nice if vger was the archive too.
> 

We probably should archive the contents, but it really doesn't seem to
matter if we outsource displaying it, does it?

	-hpa



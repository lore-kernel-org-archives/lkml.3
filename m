Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511Ab3HFVXp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:23:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43299 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755344Ab3HFVXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:23:44 -0400
Message-ID: <52016958.70005@zytor.com>
Date: Tue, 06 Aug 2013 14:23:36 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org
Subject: Re: kernel mailing list permalinks
References: <CAErSpo7eHXC-SXFYuAkkoDdhLoHzsRGh7_36wgc8=j2+qz2btA@mail.gmail.com> <CAKocOOMCsuLBsvg3npugW3EK5+UBzvQVvjeVBgTLrGrsp7o9rw@mail.gmail.com> <51FC26C7.8060108@zytor.com> <CAErSpo7z7b-i7qENa9q+8jLmsV=EFiykBy5wU1AE3eAMG1MKUA@mail.gmail.com>
In-Reply-To: <CAErSpo7z7b-i7qENa9q+8jLmsV=EFiykBy5wU1AE3eAMG1MKUA@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/2013 02:11 PM, Bjorn Helgaas wrote:
>>
>> The above link is also a good example of subtleness: + in a URL means a
>> space character, it has to be escaped as %2B.  Particularly a problem in
>> gmail message-ids.
> 
> Ooh, thanks.  I wasn't aware of that, and I've certainly constructed
> links that are semi-broken because of this issue.  Having the
> permalink in the message footer would avoid that problem.
> 
> I don't know what it would take to implement this.  Escaping special
> characters makes it not quite as trivial as I thought it might be.
> 

Part of me wonders if we could/should make the bouncer recognize that a
space character is not a valid part of a Message-ID (I think) and change
it back into a +.

A quoted Message-ID might be weird as heck, but one rarely if ever see
them, I don't know if they are even legal.

	-hpa



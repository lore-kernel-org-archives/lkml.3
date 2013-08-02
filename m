Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969Ab3HBViY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:38:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53622 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750766Ab3HBViX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:38:23 -0400
Message-ID: <51FC26C7.8060108@zytor.com>
Date: Fri, 02 Aug 2013 14:38:15 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Shuah Khan <shuahkhan@gmail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: kernel mailing list permalinks
References: <CAErSpo7eHXC-SXFYuAkkoDdhLoHzsRGh7_36wgc8=j2+qz2btA@mail.gmail.com> <CAKocOOMCsuLBsvg3npugW3EK5+UBzvQVvjeVBgTLrGrsp7o9rw@mail.gmail.com>
In-Reply-To: <CAKocOOMCsuLBsvg3npugW3EK5+UBzvQVvjeVBgTLrGrsp7o9rw@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2013 02:36 PM, Shuah Khan wrote:
> On Fri, Aug 2, 2013 at 3:04 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>> vger already adds a "to unsubscribe from this list" footer to messages
>> to LKML and other lists.  What if it also added the lkml.kernel.org
>> permalink for the message, e.g.,
>> "http://lkml.kernel.org/r/CA+55aFxb3NT3_04ZLKiCFrtTXSdi4bfQFf0HJviRRYPTW4ymXA@mail.gmail.com"?
>>
>> I often use the permalink to cite an email in bugzilla reports,
>> changelogs, other conversations, etc., and I currently dig out the
>> message-ID and construct the link by hand, so having the link directly
>> in the footer would be handy for me.  Would anybody else find this
>> useful?
>>
>> Bjorn
> 
> +1
> It would be awesome and very useful to me. I often look for lkml link
> for messages.
> 

The above link is also a good example of subtleness: + in a URL means a
space character, it has to be escaped as %2B.  Particularly a problem in
gmail message-ids.

	-hpa



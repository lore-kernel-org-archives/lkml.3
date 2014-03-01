Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752387AbaCAJ3F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 04:29:05 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43421 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaCAJ3A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 04:29:00 -0500
Message-ID: <5311A858.9080204@suse.cz>
Date: Sat, 01 Mar 2014 10:28:56 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, David Miller <davem@davemloft.net>
Subject: Re: 3.12-stable kernel tree being taken over by Jiri Slaby
References: <20140226231910.GA8789@kroah.com> <530FFC2C.5010305@roeck-us.net>
In-Reply-To: <530FFC2C.5010305@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28/2014 04:02 AM, Guenter Roeck wrote:
> On 02/26/2014 03:19 PM, Greg Kroah-Hartman wrote:
>> As I hinted at in my kernel summit talk about the stable kernel tree, we
>> have a sucker^Wvolunteer who has stepped up to take over the longterm
>> maintenance of the 3.12 stable kernel tree.
>>
>> Jiri Slaby will be doing this work, for how ever long he wants to do it.
>> I'll still be doing the final releases to kernel.org, like I do for 3.2,
>> but Jiri will be doing the collecting of patches and other real work
>> involved in it, including the announcements for its release.
>>
> 
> Jiri,

Hi,

> do you want me to keep running my build tests on the patch queue for 3.12 ?

definitely yes, if you could.

> If yes, I'll probably need to know the location of your (quilt ?)
> repository
> so I can import the patches, similar to what I do for 3.2 and the releases
> managed by Greg.

I've just published the stable-3.12-queue at:
https://git.kernel.org/cgit/linux/kernel/git/jirislaby/linux-stable.git/log/?h=stable-3.12-queue

aka

git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/linux-stable.git#stable-3.12-queue

Published trees will appear in the stable-3.12 branch in the same
repository.

thanks a lot,
-- 
js
suse labs

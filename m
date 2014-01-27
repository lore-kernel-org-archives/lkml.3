Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579AbaA0W5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 17:57:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48503 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753861AbaA0W5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 17:57:38 -0500
Message-ID: <52E6E45C.1010805@suse.cz>
Date: Mon, 27 Jan 2014 23:57:32 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Greg KH <gregkh@linux-foundation.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/7] Makefile: Build with -Werror=date-time if the compiler
 supports it
References: <cover.1387833347.git.josh@joshtriplett.org> <106ff2bbebe0c2c75bedf1c52a666d638b4dc20e.1387833347.git.josh@joshtriplett.org> <52C6E814.7090301@suse.cz> <20140103202915.GB12111@leaf> <52C723B4.1080902@suse.cz> <20140103210030.GE12111@leaf> <52D5A495.80500@suse.cz> <20140114214014.GA10837@jtriplet-mobl1> <20140114214614.GA26965@kroah.com>
In-Reply-To: <20140114214614.GA26965@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2014 22:46, Greg KH wrote:
> On Tue, Jan 14, 2014 at 01:40:15PM -0800, Josh Triplett wrote:
>> On Tue, Jan 14, 2014 at 09:56:53PM +0100, Michal Marek wrote:
>>> Dne 3.1.2014 22:00, Josh Triplett napsal(a):
>>>> On Fri, Jan 03, 2014 at 09:55:16PM +0100, Michal Marek wrote:
>>>>> On 3.1.2014 21:29, Josh Triplett wrote:
>>>>>> Please feel free to take the entire series through your tree; I received
>>>>>> some maintainer acks, but no indications that the patches are going
>>>>>> through their trees.
>>>>>
>>>>> OK. I will wait until mid next week and commit with any acks received.
>>>>
>>>> Thanks!
>>>
>>> I did not find time last week and Greg was faster and merged the driver
>>> patches. But I'm reluctant to only merge the Makefile patch now, because
>>> the kbuild branch would not build. I think I will send the patch to
>>> Linus after 3.14-rc1.
>>
>> Greg, if you already have all the driver patches in your tree, perhaps
>> you could go ahead and take the Makefile patch through your tree as
>> well?  (Assuming that's OK with you, Michal?)
> 
> Did I really grab all of the other patches?  I don't remember how many
> there were in this series for stuff I maintain.  If I have them all,
> sure, I'll be glad to take it, otherwise I agree with Michal, it should
> be sent to Linus after 3.14-rc1 is out to make sure everything is
> properly synced up and you didn't miss any new drivers coming in that
> missed getting converted.

FYI: The remaining patches are now in the kbuild.git#drop-time branch
and also in the for-next branch.

Thanks,
Michal

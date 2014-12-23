Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630AbaLWEMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 23:12:05 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:32814 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583AbaLWEME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 23:12:04 -0500
Message-ID: <5498EB66.6070004@gmail.com>
Date: Tue, 23 Dec 2014 09:41:18 +0530
From: Sanchayan Maity <maitysanchayan@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Chen <peter.chen@freescale.com>
CC: stefan@agner.ch, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] usb: chipidea: add one errata for revision 2.40a
References: <cover.1418981438.git.maitysanchayan@gmail.com> <20141222011840.GB9242@shlinux2> <54981816.4010708@gmail.com> <20141223000940.GA11551@shlinux2>
In-Reply-To: <20141223000940.GA11551@shlinux2>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/2014 05:39 AM, Peter Chen wrote:
> On Mon, Dec 22, 2014 at 06:39:42PM +0530, Sanchayan Maity wrote:
>> On 12/22/2014 06:48 AM, Peter Chen wrote:
>>> On Fri, Dec 19, 2014 at 03:25:26PM +0530, Sanchayan Maity wrote:
>>>> The first two patches add identification register API's. These can
>>>> be used to get controller's revision. 
>>>>
>>>> The third patch implements an errata for revision 2.40a. Not sure
>>>> which other SOCs implement this version of the Chipidea core but
>>>> this fixes the usb client issue observed on Vybrids. The patch was
>>>> tested on a Toradex Colibri VF61 module with the 3.18 kernel. iperf
>>>> tests ran for three hours plus, with these patches applied have found
>>>> the USB client connection to be now reliable.
>>>
>>> Would you help do a overnight test? It is passed, I will queue them,
>>> thanks.
>>
>> Yes definitely I can help with the testing. Are you looking for iperf
>> tests only or something else? iperf tests running for 12 or 24 hours 
>> will do? I will need a bit of time to set things up here, as I am away
>> from work, but, ya I will do them. 
>>
> 
> iperf for g_ncm or g_ether and bonnie++ for g_mass_storage if you can
> run, thanks.

Will run 12 hour iperf test for CDC ECM. I am not aware of bonnie++, but,
will look into it. Will get back once I have the results.

Thanks.

Regards,
Sanchayan.

> 
> Peter
> 
>> -Regards,
>> Sanchayan.
>>>
>>> Peter
>>>>
>>>> This patchset is based off on Shawn Guo's for-next branch
>>>> https://git.kernel.org/cgit/linux/kernel/git/shawnguo/linux.git/tree/?h=for-next
>>>>
>>>> The credit for the patches and fix goes to Matthieu Castet and Peter Chen.
>>>> First two patches are by Peter Chen and the third patch which fixed the
>>>> bug we observed was reported by Matthieu Castet.
>>>>
>>>> The discussion of the problem and the relevant testing details can be found
>>>> at this link: http://www.spinics.net/lists/linux-usb/msg118544.html
>>>>
>>>> The first version of this patchset originally send by Peter Chen can be
>>>> found at this link: http://www.spinics.net/lists/linux-usb/msg118753.html
>>>>
>>>> Comments for review are welcome :).
>>>> Note: I am going on a vacation so will not be able to reply or do any further
>>>> tests till Monday. Will attend and take care of any comments/requests for 
>>>> further changes/testing from Tuesday. Apologize for the delay in advance.
>>>>
>>>> Sanchayan Maity (3):
>>>>   usb: chipidea: Add identification registers access APIs
>>>>   usb: chipidea: Add chipidea revision information
>>>>   usb: chipidea: Add errata for revision 2.40a
>>>>
>>>>  drivers/usb/chipidea/bits.h |   10 ++++++++
>>>>  drivers/usb/chipidea/ci.h   |   53 +++++++++++++++++++++++++++++++++++++++++++
>>>>  drivers/usb/chipidea/core.c |   23 +++++++++++++++++--
>>>>  drivers/usb/chipidea/udc.c  |   20 ++++++++++++++++
>>>>  4 files changed, 104 insertions(+), 2 deletions(-)
>>>>
>>>> -- 
>>>> 1.7.9.5
>>>>
>>>
> 

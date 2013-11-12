Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754347Ab3KLBMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 20:12:54 -0500
Received: from ns3.fnarfbargle.com ([103.4.17.7]:35754 "EHLO
	ns3.fnarfbargle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab3KLBMo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 20:12:44 -0500
X-Greylist: delayed 1996 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Nov 2013 20:12:44 EST
Message-ID: <528178B8.4000704@fnarfbargle.com>
Date: Tue, 12 Nov 2013 08:39:20 +0800
From: Brad Campbell <lists2009@fnarfbargle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Justin Piszcz <jpiszcz@lucidpixels.com>,
        open list <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
Subject: Re: 3.12: raid-1 mismatch_cnt question
References: <000f01ced948$2fbab140$8f3013c0$@lucidpixels.com> <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
In-Reply-To: <CAO9zADxbiW_OBiewAY8JQQjxS51Ydrm8Rj1=MWXCA+Xo9K3=2Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 06:54 PM, Justin Piszcz wrote:
> On Mon, Nov 4, 2013 at 5:25 AM, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>> Hi,
>>
>> I run two SSDs in a RAID-1 configuration and I have a swap partition on a
>> third SSD.  Over time, the mismatch_cnt between the two devices grows higher
>> and higher.
>>

Are both SSD's identical? Do you have discard enabled on the filesystem?

The reason I ask is I have a RAID10 comprised of 3 Intel and 3 Samsung 
SSD's. The Intel return 0 after TRIM while the Samsung don't, so I 
_always_ have a massive mismatch_cnt after I run fstrim. I never use a 
repair operation as it's just going to re-write the already trimmed sectors.


Just a thought.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372AbaBDTvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:51:36 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:5198 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932293AbaBDTvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:51:31 -0500
Message-ID: <52F14517.5080102@fb.com>
Date: Tue, 4 Feb 2014 14:52:55 -0500
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <dsterba@suse.cz>, Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs
References: <52EAC9B6.7090603@fb.com> <20140203175405.GL1364@twin.jikos.cz> <52EFDD80.4050800@fb.com> <20140204195016.GA5264@kroah.com>
In-Reply-To: <20140204195016.GA5264@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-04_06:2014-02-04,2014-02-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.55431223447522e-14 kscore.compositescore=0
 circleOfTrustscore=10.6820669334155 compositescore=0.998049563855454
 urlsuspect_oldscore=0.998049563855454 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=64355
 rbsscore=0.998049563855454 spamscore=0
 recipient_to_sender_domain_totalscore=27 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1305240000
 definitions=main-1402040108
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/04/2014 02:50 PM, Greg KH wrote:
> On Mon, Feb 03, 2014 at 01:18:40PM -0500, Chris Mason wrote:
>> On Mon 03 Feb 2014 12:54:05 PM EST, David Sterba wrote:
>>> On Thu, Jan 30, 2014 at 04:52:54PM -0500, Chris Mason wrote:
>>>> Chris Mason (3) commits (+64/-32):
>>>>      Btrfs: setup inode location during btrfs_init_inode_locked (+9/-9)
>>>>      Btrfs: don't use ram_bytes for uncompressed inline items (+52/-22)
>>>
>>> The patches are CC: stable, but haven't gone through the mailinglist.
>>> Are they still going to be picked by stable?
>>
>> We do need both in -stable, I'll help with backports.
>
> Very few of the patches you marked for -stable, actually would apply (or
> build once applied.)  Can you please send a set of patches you want
> applied?

Yes, I'll make a tree for you to pull.  Between the acls and the block 
layer changes, we had a lot of little things that will make it hard to 
apply them directly, but the backports are pretty easy.

-chris


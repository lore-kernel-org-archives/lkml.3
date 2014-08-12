Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399AbaHLRjV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 13:39:21 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16691 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753903AbaHLRjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 13:39:19 -0400
Message-ID: <53EA513F.3080804@fb.com>
Date: Tue, 12 Aug 2014 13:39:11 -0400
From: Chris Mason <clm@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>, Josef Bacik <jbacik@fb.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: Fix memory corruption by ulist_add_merge() on
 32bit arch
References: <1406537824-2376-1-git-send-email-tiwai@suse.de>	<53D64D40.80606@fb.com>	<s5hzjft7fwm.wl%tiwai@suse.de>	<s5hsill7fak.wl%tiwai@suse.de>	<s5hsiljrwwy.wl%tiwai@suse.de>	<53D9015A.90001@fb.com>	<s5h61iesxen.wl%tiwai@suse.de>	<s5h1tt2sx94.wl%tiwai@suse.de>	<53D911DE.7000806@fb.com>	<s5hwqaurgic.wl%tiwai@suse.de>	<53D916DB.9020901@fb.com>	<s5hsilirehv.wl%tiwai@suse.de>	<53D924A8.2050008@fb.com>	<s5ha97q91vj.wl%tiwai@suse.de> <s5h38d94pm7.wl%tiwai@suse.de>
In-Reply-To: <s5h38d94pm7.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-12_07:2014-08-12,2014-08-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=6.09340355950394e-12 kscore.compositescore=0
 circleOfTrustscore=29.7083259529277 compositescore=0.9989857498195
 urlsuspect_oldscore=0.9989857498195 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.9989857498195 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1408120186
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/06/2014 11:14 AM, Takashi Iwai wrote:
>>>
>>> I meant that I don't care how you do it, if you want to do it the simple way
>>> first and then send the cleanup later thats fine by me.  Thanks,
>>
>> Ah, misunderstood.  Then please disregard my v2 patches and take just
>> v1 patch.  It's even good for 3.16, if possible.
>>
>> I'll send the cleanup patch on top of that.
> 
> Ping.  I don't want to play a bot, but slowly wondering what's going
> on...

Sorry for the delay Takashi.  This patch is a ';' away from compiling.
I've fixed it up here and I'm running tests, but I wanted to double
check this was the latest version.

-chris

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab3GIVzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 17:55:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60336 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752150Ab3GIVyx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 17:54:53 -0400
Subject: Re: [PATCH 0/2] powerpc: allow kvm to use kerel debug framework
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <14504.1373343872@ale.ozlabs.ibm.com>
Date: Tue, 9 Jul 2013 23:54:44 +0200
Cc: Bharat Bhushan <r65777@freescale.com>, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        scottwood@freescale.com, Bharat Bhushan <bharat.bhushan@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <636D011A-6C50-4E74-B4B2-658EC4E53E9C@suse.de>
References: <1372918546-15075-1-git-send-email-Bharat.Bhushan@freescale.com> <C4D71A1A-3D5B-4C9C-A26B-9EAFFD9D87C5@suse.de> <14504.1373343872@ale.ozlabs.ibm.com>
To: Michael Neuling <mikey@neuling.org>
X-Mailer: Apple Mail (2.1278)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09.07.2013, at 06:24, Michael Neuling wrote:

> Alexander Graf <agraf@suse.de> wrote:
> 
>> 
>> On 04.07.2013, at 08:15, Bharat Bhushan wrote:
>> 
>>> From: Bharat Bhushan <bharat.bhushan@freescale.com>
>>> 
>>> This patchset moves the debug registers in a structure, which allows
>>> kvm to use same structure for debug emulation.
>>> 
>>> Note: Earilier a patchset "https://lists.ozlabs.org/pipermail/linuxppc-dev/2013-June/108132.html"
>>> was sent which is a bunch of six patches. That patchset is divided into two parts:
>>> 	1) powerpc specific changes (These 2 patches are actually have those changes)
>>> 	2) KVM specific changes (will send separate patch on agraf repository)
>> 
>> Mikey, if you like those could you please apply the into a topic
>> branch and get that one merged with Ben? I'd also pull it into my tree
>> then.
> 
> benh would pull these directly.  
> 
> I'll have a chat with him to see if he wants my ACK before he does that.

I have a bunch of patches that I need to apply on top, so I need a topic branch.


Alex


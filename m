Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaFLBOJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:14:09 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:57670 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaFLBOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:14:07 -0400
MIME-Version: 1.0
In-Reply-To: <874mzrszlk.fsf@x220.int.ebiederm.org>
References: <CAJE_dJyfq5zWcs2y52siXRruCCA1Dk_=Ds=rZ8BrBZLa7FCbuQ@mail.gmail.com>
	<20140611133919.GZ4581@linux.vnet.ibm.com>
	<CAJE_dJwfaUkop=XZxD-BfDPwKDjnfF1bvmD6XWaqVA4Xt2E6bQ@mail.gmail.com>
	<539879B8.4010204@canonical.com>
	<20140611161857.GC4581@linux.vnet.ibm.com>
	<53989F7B.6000004@canonical.com>
	<874mzr41kf.fsf@x220.int.ebiederm.org>
	<20140611225228.GO4581@linux.vnet.ibm.com>
	<87ioo7vy5s.fsf@x220.int.ebiederm.org>
	<20140611234902.GQ4581@linux.vnet.ibm.com>
	<87bntzt24g.fsf@x220.int.ebiederm.org>
	<CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
	<874mzrszlk.fsf@x220.int.ebiederm.org>
Date: Wed, 11 Jun 2014 22:14:07 -0300
Message-ID: <CAJE_dJzShXxjsywRo_kwa0ez6Seu7+dModbz2Lvha5iuJw7FTw@mail.gmail.com>
Subject: Re: Possible netns creation and execution performance/scalability
 regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
From: Rafael Tinoco <rafael.tinoco@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, some misconfiguration here probably, never mind. I'll finish the
tests tomorrow, compare with existent ones and let you know asap. Tks.

On Wed, Jun 11, 2014 at 10:09 PM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Rafael Tinoco <rafael.tinoco@canonical.com> writes:
>
>> I'm getting a kernel panic with your patch:
>>
>> -- panic
>> -- mount_block_root
>> -- mount_root
>> -- prepare_namespace
>> -- kernel_init_freeable
>>
>> It is giving me an unknown block device for the same config file i
>> used on other builds. Since my test is running on a kvm guest under a
>> ramdisk, i'm still checking if there are any differences between this
>> build and other ones but I think there aren't.
>>
>> Any chances that "prepare_namespace" might be breaking mount_root ?
>
> My patch boots for me....
>
> Eric



-- 
-- 
Rafael David Tinoco
Software Sustaining Engineer @ Canonical
Canonical Technical Services Engineering Team
# Email: rafael.tinoco@canonical.com (GPG: 87683FC0)
# Phone: +55.11.9.6777.2727 (Americas/Sao_Paulo)
# LP: ~inaddy | IRC: tinoco | Skype: rafael.tinoco

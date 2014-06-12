Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755341AbaFLBKi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:10:38 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43931 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaFLBKg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:10:36 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rafael Tinoco <rafael.tinoco@canonical.com>
Cc: Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Dave Chiluk <chiluk@canonical.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, Christopher Arges <chris.j.arges@canonical.com>,
        Jay Vosburgh <jay.vosburgh@canonical.com>
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
Date: Wed, 11 Jun 2014 18:09:27 -0700
In-Reply-To: <CAJE_dJzzj2uf+YEXhAngJDKev=Lc4O6fyKfHoO2PbzD90VuuVw@mail.gmail.com>
	(Rafael Tinoco's message of "Wed, 11 Jun 2014 21:25:52 -0300")
Message-ID: <874mzrszlk.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/11W0kVknqiSrKtvkkhIg3BkXmg4kB5v0=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4766]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rafael Tinoco <rafael.tinoco@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: Possible netns creation and execution performance/scalability regression since v3.8 due to rcu callbacks being offloaded to multiple cpus
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael Tinoco <rafael.tinoco@canonical.com> writes:

> I'm getting a kernel panic with your patch:
>
> -- panic
> -- mount_block_root
> -- mount_root
> -- prepare_namespace
> -- kernel_init_freeable
>
> It is giving me an unknown block device for the same config file i
> used on other builds. Since my test is running on a kvm guest under a
> ramdisk, i'm still checking if there are any differences between this
> build and other ones but I think there aren't.
>
> Any chances that "prepare_namespace" might be breaking mount_root ?

My patch boots for me....

Eric

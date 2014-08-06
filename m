Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128AbaHFOFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:05:25 -0400
Received: from mail.wdtv.com ([66.118.69.84]:41134 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaHFOFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:05:24 -0400
X-Greylist: delayed 442 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Aug 2014 10:05:24 EDT
From: Gene Heskett <gheskett@wdtv.com>
To: "Lan, Tianyu" <tianyu.lan@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Date: Wed, 6 Aug 2014 09:57:58 -0400
Cc: Borislav Petkov <bp@alien8.de>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "toshi.kani@hp.com" <toshi.kani@hp.com>,
        "imammedo@redhat.com" <imammedo@redhat.com>,
        "jan.kiszka@siemens.com" <jan.kiszka@siemens.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "huawei.libin@huawei.com" <huawei.libin@huawei.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandt, Todd E" <todd.e.brandt@intel.com>
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com> <20140806110748.GC27033@pd.tnic> <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com>
In-Reply-To: <4CFBC02C07DA244CA19D6815A05BE6EE0119E1CF@SHSMSX103.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201408060957.59268.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 06 August 2014, Lan, Tianyu wrote:
>Have you tried my attached kernel config file? When someone reported
>the issue to me, I also was very hard to reproduce the issue by my own
>config file. Maybe once 100 tries. But I can reproduced the issue every
>time with the attached configure file on several my machines and even
>on server.

There was no attachment.
>
>-----Original Message-----
>From: Borislav Petkov [mailto:bp@alien8.de]
>Sent: Wednesday, August 06, 2014 7:08 PM
>To: Lan, Tianyu
>Cc: tglx@linutronix.de; mingo@redhat.com; hpa@zytor.com; x86@kernel.org;
>toshi.kani@hp.com; imammedo@redhat.com; jan.kiszka@siemens.com;
>mingo@kernel.org; huawei.libin@huawei.com; prarit@redhat.com;
>linux-kernel@vger.kernel.org; Brandt, Todd E Subject: Re: [PATCH]
>X86/CPU: Avoid 100ms sleep for cpu offline during S3
>
>On Tue, Aug 05, 2014 at 05:29:18PM +0800, Lan Tianyu wrote:
>> I think you can pull Tod's tool from git hub and do test from your
>> laptop. I attached a configure file come from ubuntu which is easier
>> to produce the issue. You can use it to reproduce the issue.
>
>Right, so I ran it on an old dualcore AMD laptop I have lying around
>here and it didn't show any difference with or without your patch.
>
>For all 4 runs I did with the tool running it without any arguments (so
>it did the default thing), I got suspend time for CPU1 of 4-6 msec and
>resume of ~20msec.
>
>I don't know whether it is the dual core or AMD but your patch doesn't
>change anything on that laptop which is ok, I'd guess.
>
>> Ok. BTW, I have tested it on the Ivbridge and Haswell machines.
>
>Yeah, add those numbers to the commit message too.
>
>Thanks.
>
>--
>Regards/Gruss,
>    Boris.
>
>Sent from a fat crate under my desk. Formatting is fine.
>--


Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS

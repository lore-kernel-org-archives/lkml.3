Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107AbaHGKXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 06:23:44 -0400
Received: from mail.wdtv.com ([66.118.69.84]:45114 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757283AbaHGKXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 06:23:43 -0400
From: Gene Heskett <gheskett@wdtv.com>
To: Lan Tianyu <tianyu.lan@intel.com>
Subject: Re: [PATCH] X86/CPU: Avoid 100ms sleep for cpu offline  during S3
Date: Thu, 7 Aug 2014 06:23:40 -0400
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
References: <1407142742-29202-1-git-send-email-tianyu.lan@intel.com> <201408060957.59268.gheskett@wdtv.com> <53E33D39.7040706@intel.com>
In-Reply-To: <53E33D39.7040706@intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201408070623.41026.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 August 2014, Lan Tianyu wrote:
>On 2014年08月06日 21:57, Gene Heskett wrote:
>> On Wednesday 06 August 2014, Lan, Tianyu wrote:
>>> Have you tried my attached kernel config file? When someone reported
>>> the issue to me, I also was very hard to reproduce the issue by my
>>> own config file. Maybe once 100 tries. But I can reproduced the
>>> issue every time with the attached configure file on several my
>>> machines and even on server.
>> 
>> There was no attachment.
>
>Hi Gene:
>	Sorry. I meant the config file I attached in the my last reply.
>
NP.  I track this list looking for trends but don't always build the 
latest whizbang kernel unless I'm fighting with a specific problem.
Using an old kmail, I thought I could improve its performance with shorter 
expiry times on busy lists.  Not as helpful as I'd hoped.  Once a certain 
number of read mails exist, 1.13.5 has to be stopped and restarted 
immediately else it takes several seconds to find the next unread.

Sorry for the noise.

Cheers, Gene Heskett
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>
US V Castleman, SCOTUS, Mar 2014 is grounds for Impeaching SCOTUS

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750771Ab3HSDg5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Aug 2013 23:36:57 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:56750 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab3HSDg4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Aug 2013 23:36:56 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5211831B.6090704@jp.fujitsu.com>
References: <5200BFB3.2050202@jp.fujitsu.com> <520A10A3.5080303@hp.com> <520B4A22.2030800@hp.com> <87ob90839p.fsf@xmission.com> <5211831B.6090704@jp.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
From: "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sun, 18 Aug 2013 19:59:53 -0700
To: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
CC: Jingbai Ma <jingbai.ma@hp.com>, Fenghua Yu <fenghua.yu@intel.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Mitchell, Lisa (MCLinux in Fort Collins)" <lisa.mitchell@hp.com>,
        "H. Peter Anvin" <hpa@zytor.com>, bhelgaas@google.com,
        Vivek Goyal <vgoyal@redhat.com>
Message-ID: <a2ff8170-41ad-42f6-9015-850dbe14983d@email.android.com>
X-XM-AID: U2FsdGVkX18HWVW6WXWQYeJkwEp2TtUovC59aTdGcXI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5030]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Spam-Relay-Country: 
Subject: Re: [Help Test] kdump, x86, acpi: Reproduce CPU0 SMI corruption issue after unsetting BSP flag
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org




>
>Sorry Eric, I'm not clear to what you mean by ``short one core''...
>Which are you suggesting? Disabling BSP if crash happens on AP is
>reasonable?
>Or restricting cpus to a single one only just as the current kdump
>configuration is reasonable?

I am suggesting we start every cpu except the BSP from the AP we started on.

N-1 cpus seems like a good tradeoff between performance and reliability for those who need it.

Eric


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754534AbaDKRv6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 13:51:58 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.108]:38100 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750863AbaDKRv5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 13:51:57 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-14.tower-200.messagelabs.com!1397238714!16095417!1
X-Originating-IP: [192.61.61.105]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: "Romer, Benjamin M" <Benjamin.Romer@unisys.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jet Chen <jet.chen@intel.com>, Fengguang Wu <fengguang.wu@intel.com>,
        Paolo Bonzini <pbonzini@redhat.com>, Borislav Petkov <bp@alien8.de>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 11 Apr 2014 12:51:53 -0500
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Topic: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
Thread-Index: Ac9VrrkIEAXHC4aeR0qj17TZunP1Vg==
Message-ID: <C97001BC43954D438ACB059713BA5CDF92040F0F13@USEA-EXCH7.na.uis.unisys.com>
References: <20140407111725.GC25152@localhost>
 <C97001BC43954D438ACB059713BA5CDF92040F0F00@USEA-EXCH7.na.uis.unisys.com>
 <53444220.50009@intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F06@USEA-EXCH7.na.uis.unisys.com>
 <53458A3A.1050608@intel.com> <20140409230114.GB8370@localhost>
 <5345D360.5000506@linux.intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F0A@USEA-EXCH7.na.uis.unisys.com>
 <53475344.5090009@linux.intel.com>
 <C97001BC43954D438ACB059713BA5CDF92040F0F10@USEA-EXCH7.na.uis.unisys.com>
 <53481976.3020209@zytor.com> <534827F5.1020004@intel.com>
 <5348291B.7090501@zytor.com>
In-Reply-To: <5348291B.7090501@zytor.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s3BHq6hf006213

On Fri, 2014-04-11 at 10:40 -0700, H. Peter Anvin wrote:
> On 04/11/2014 10:35 AM, Jet Chen wrote:
> > 
> > As Peter said, QEMU probably should *not* set the hypervisor bit. But based on my testing, I think KVM works properly in this case.
> > 
> 
> Either way, unless there is a CPUID interface exposed in CPUID levels
> 0x40000000+, then relying on the hypervisor bit to do VMCALL is wrong in
> the extreme.
> 
> 	-hpa
> 
> 

I'll pass your feedback on to the people who wrote the bad code. Sorry
for the trouble. :)

-- Ben
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

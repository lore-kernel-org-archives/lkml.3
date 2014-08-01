Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbaHAJ7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 05:59:45 -0400
Received: from blu004-omc2s30.hotmail.com ([65.55.111.105]:63438 "EHLO
	BLU004-OMC2S30.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750831AbaHAJ7n convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 05:59:43 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2014 05:59:43 EDT
X-TMN: [on+MhUhFEcJL1EkiA1z4fWUa6pLeJvUL]
X-Originating-Email: [yuhongbao_386@hotmail.com]
Message-ID: <BLU177-W18D4117284A1222D08D213C3E70@phx.gbl>
From: Yuhong Bao <yuhongbao_386@hotmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>,
        "jerry.hoemann@hp.com" <jerry.hoemann@hp.com>
CC: "rob@landley.net" <rob@landley.net>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        "yinghai@kernel.org" <yinghai@kernel.org>,
        "penberg@kernel.org" <penberg@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>
Subject: RE: [PATCH 0/3] Early use of boot service memory
Date: Fri, 1 Aug 2014 02:54:34 -0700
Importance: Normal
In-Reply-To: <528413DE.1090203@zytor.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
 <d73ccce9-6a0d-4470-bda3-f0c6eb96b5e4@email.android.com>
 <20131113224503.GB25344@anatevka.fc.hp.com> <52840206.5020006@zytor.com>
 <20131113235708.GC25344@anatevka.fc.hp.com>,<528413DE.1090203@zytor.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 01 Aug 2014 09:54:34.0703 (UTC) FILETIME=[994D6DF0:01CFAD6E]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> I think i can go to a date based black list, that removes the manual
>> step. System running firmware before certain date assumes we need
>> to do the work around. If firmware is newer than that date, we don't
>> use the workaround. Blacklist overrides and allows current behavior
>> for new firmware that is subsequently found to be broken and for
>> which we can't convenience the manufacturer to fix.
>>
>
> No, we can't, at least not for now. We are continually finding new
> platforms with the bug.

What about now?

ot, but this is a fun read:
http://download.lenovo.com/ibmdl/pub/pc/pccbbs/thinkcentre_bios/9sjy81usa.txt
Notice the reference to "redhat 6.3"! 		 	   		  
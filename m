Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaAUQkE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 11:40:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754836AbaAUQkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 11:40:00 -0500
Message-ID: <52DEA14E.2030602@redhat.com>
Date: Tue, 21 Jan 2014 17:33:18 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Liu, Jinsong" <jinsong.liu@intel.com>
CC: "gleb@redhat.com" <gleb@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Qiaowei" <qiaowei.ren@intel.com>
Subject: Re: [PATCH v2 0/4] X86/KVM: enable Intel MPX for KVM
References: <1386394315-48984-1-git-send-email-jinsong.liu@intel.com> <DE8DF0795D48FD4CA783C40EC82923350141B4A7@SHSMSX101.ccr.corp.intel.com> <52A83606.40908@redhat.com> <DE8DF0795D48FD4CA783C40EC829233501421D73@SHSMSX101.ccr.corp.intel.com> <52A98548.9010008@redhat.com> <DE8DF0795D48FD4CA783C40EC829233501422743@SHSMSX101.ccr.corp.intel.com> <52DD3427.9020502@redhat.com> <DE8DF0795D48FD4CA783C40EC82923350149CB2D@SHSMSX101.ccr.corp.intel.com>
In-Reply-To: <DE8DF0795D48FD4CA783C40EC82923350149CB2D@SHSMSX101.ccr.corp.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 21/01/2014 16:25, Liu, Jinsong ha scritto:
> Hmm? I remember I have sent out the rebased patches v3 last month
> If you didn't receive them I'm OK to rebase and resend them. BTW, what's
> the review remarks? I remember you commented that the patches are fine.
> Any misunderstanding please point out to me.

You sent v3 of QEMU, but not of KVM.  I don't see any mail from you 
after December 12th on kvm@vger.kernel.org.

I can see my comment that the patches were fine (apart from needing a 
rebase), but the threading was wrong and I cannot find anymore _which_ 
patches they were.  I did find a comment that BNDCFGS must be added to 
msrs_to_save, but I don't know if that was v1 or v2 because you didn't 
add the version number when sending v2.

Paolo

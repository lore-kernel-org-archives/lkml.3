Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966564Ab3DQOIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:08:19 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58375 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966400Ab3DQOIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:08:17 -0400
Message-ID: <C608646D0DB149C0B7B853090B7F4B05@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "Jan Beulich" <JBeulich@suse.com>, <olaf@aepfle.de>, <bp@alien8.de>,
        "\"Andy Whitcroft\"" <apw@canonical.com>, <x86@kernel.org>,
        <tglx@linutronix.de>, <devel@linuxdriverproject.org>,
        "Greg KH" <gregkh@linuxfoundation.org>,
        "K. Y. Srinivasan" <kys@microsoft.com>, <jasowang@redhat.com>,
        <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
References: <1359940910-32114-1-git-send-email-kys@microsoft.com> <1359940959-32168-1-git-send-email-kys@microsoft.com> <1359940959-32168-2-git-send-email-kys@microsoft.com> <20130417070616.GA4487@redhat.com> <39D7C3658A5B4979A3F025E1D944E743@local.st.by> <20130417101617.GF3881@redhat.com> <516EADD502000078000CE112@nat28.tlf.novell.com> <CAP2xkNqGgbYz1gdS85xjA8gwROGY89fAsiaRiGSE90xnzjJ4Xw@mail.gmail.com> <20130417124352.GC6801@redhat.com>
Subject: Re: KVM "Hyper-V emulation" -- this can be related "Linux on Hyper-V" ? Or "KVM emulates Hyper-V" as "Hyper-V emulates Hyper-V" ? Re: [PATCH 2/3] X86: Add a check to catch Xen emulation of Hyper-V
Date: Wed, 17 Apr 2013 17:08:11 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4862
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

>> This is _positive_ variant of possible future,
>> but on _practic_ very often we need prevent _negative_ variant of possible
>> future
> 
> I don't really know what this means.
>

 On practic: this means, that need test with KVM "Hyper-V emulation" not only Windows guest, but _all_ Linux guest

_all_ Linux need read -- not only RHEL, but 
-- Debian 7.X ( kernell v3.2 with own hotfixes set) , 
-- Ubuntu 12.04 LTS ( kernell v3.2 with hotfixes)
-- Ubuntu 12.04.03 LTS ( kernell v3.5 with hotfixes)
-- Ubuntu 12.10 ( kernell v3.5 with hotfixes)
-- Linuxes with kernel v3.6 / or v3.7
-- Linuxes with latest stable kernel v3.8 ( for example Arch Linux)
-- other possible variants

Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/


P.S.
  I'm personal not want, what KVM "Hyper-V emulation" initiative stopped implemented
If it work as need -- this is very good


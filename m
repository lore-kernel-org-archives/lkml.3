Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761447Ab3BNBWK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:22:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46703 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753483Ab3BNBWH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:22:07 -0500
Message-ID: <511C3BDE.5060503@zytor.com>
Date: Wed, 13 Feb 2013 17:20:30 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        linux EFI ml <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-stable ml <stable@vger.kernel.org>,
        linux x86 ml <x86@kernel.org>, David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT
 by "noefi" boot parameter
References: <511C2C04.2070108@jp.fujitsu.com>
In-Reply-To: <511C2C04.2070108@jp.fujitsu.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 04:12 PM, Satoru Takeuchi wrote:
> From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> 
> There was a serious problem in samsung-laptop that its platform driver is
> designed to run under BIOS and running under EFI can cause the machine to
> become bricked or can cause Machine Check Exceptions.
> 

Matt, unless you object I'll pick this one up as urgent, please take the
cleanup patch in normal order.

	-hpa



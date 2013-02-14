Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177Ab3BNHh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 02:37:59 -0500
Received: from mail-we0-f181.google.com ([74.125.82.181]:45362 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755857Ab3BNHh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 02:37:57 -0500
Message-ID: <1360827472.24917.35.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [PATCH] efi: Clear EFI_RUNTIME_SERVICES rather than EFI_BOOT by
 "noefi" boot parameter
From: Matt Fleming <matt.fleming@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        linux EFI ml <linux-efi@vger.kernel.org>,
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
Date: Thu, 14 Feb 2013 07:37:52 +0000
In-Reply-To: <511C3BDE.5060503@zytor.com>
References: <511C2C04.2070108@jp.fujitsu.com> <511C3BDE.5060503@zytor.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 17:20 -0800, H. Peter Anvin wrote:
> On 02/13/2013 04:12 PM, Satoru Takeuchi wrote:
> > From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
> > 
> > There was a serious problem in samsung-laptop that its platform driver is
> > designed to run under BIOS and running under EFI can cause the machine to
> > become bricked or can cause Machine Check Exceptions.
> > 
> 
> Matt, unless you object I'll pick this one up as urgent, please take the
> cleanup patch in normal order.

No objection from me, this looks correct.


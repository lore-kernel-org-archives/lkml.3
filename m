Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3BUKdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 05:33:32 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:40499 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3BUKda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 05:33:30 -0500
Message-ID: <1361442806.2842.2.camel@mfleming-mobl1.ger.corp.intel.com>
Subject: Re: [tip:x86/urgent] x86, efi: Make "noefi" really disable EFI
 runtime serivces
From: Matt Fleming <matt.fleming@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, takeuchi_satoru@jp.fujitsu.com,
        tglx@linutronix.de, walt0924@gmail.com, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Date: Thu, 21 Feb 2013 10:33:26 +0000
In-Reply-To: <CAE9FiQWnaGzDEko=sCzvT8LS7heZ7miwiVU+T4eJk-JgSr_Z4w@mail.gmail.com>
References: <1361392572-25657-1-git-send-email-matt@console-pimps.org>
	 <tip-fb834c7acc5e140cf4f9e86da93a66de8c0514da@git.kernel.org>
	 <CAE9FiQWnaGzDEko=sCzvT8LS7heZ7miwiVU+T4eJk-JgSr_Z4w@mail.gmail.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-20 at 16:16 -0800, Yinghai Lu wrote:
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
> > index 928bf83..e2cd38f 100644
> > --- a/arch/x86/platform/efi/efi.c
> > +++ b/arch/x86/platform/efi/efi.c
> > @@ -85,9 +85,10 @@ int efi_enabled(int facility)
> >  }
> >  EXPORT_SYMBOL(efi_enabled);
> >
> > +static bool disable_runtime = false;
> 
> __initdata please.

Sure. Peter, please drop this. I'll submit a v2.


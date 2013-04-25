Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab3DYLkj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 07:40:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:60006 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185Ab3DYLki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 07:40:38 -0400
Message-ID: <51791633.7070604@intel.com>
Date: Thu, 25 Apr 2013 12:40:35 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Ingo Molnar <mingo@kernel.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: [PATCH] x86, efi: Fix a build warning
References: <1366798154-1380-1-git-send-email-bp@alien8.de> <20130424105610.GA15815@gmail.com> <5177BF67.2040308@intel.com> <20130425065529.GD7806@gmail.com> <5178D8E9.7020102@intel.com> <20130425104729.GB32607@pd.tnic>
In-Reply-To: <20130425104729.GB32607@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/04/13 11:47, Borislav Petkov wrote:
> I wonder - if efi_runtime_service_t contained only void * like
> efi_boot_services_t then we could drop all the casts too, right? Even in
> the efi_call* macro calls too...

Yeah, that's what I figured.

> If you want me, I can take care of it after the merge window :)

That would be very helpful, thank you!

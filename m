Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211Ab3D3L1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:27:37 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:55744 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3D3L1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:27:36 -0400
Message-ID: <517FAAA3.50303@intel.com>
Date: Tue, 30 Apr 2013 12:27:31 +0100
From: Matt Fleming <matt.fleming@intel.com>
Organization: Intel Corporation (UK) Ltd. - Registered No. 1134945 - Pipers
 Way, Swindon SN3 1RJ
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Seiji Aguchi <seiji.aguchi@hds.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
        "mjg59@srcf.ucam.org" <mjg59@srcf.ucam.org>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        "jk@ozlabs.org" <jk@ozlabs.org>, "teg@jklm.no" <teg@jklm.no>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mikew@google.com" <mikew@google.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [tip:x86/efi2] efivars: efivar_entry API
References: <tip-e14ab23dde12b80db4c94b684a2e485b72b16af3@git.kernel.org> <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD20E4@USINDEM103.corp.hds.com>
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D41AFD20E4@USINDEM103.corp.hds.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/04/13 16:43, Seiji Aguchi wrote:
> I tested pstore_read() as well.
> And /dev/pstore/dmesg-efi-X was empty....
> 
> This must be __efivar_entry_get() instead of __efivar_entry_size().
> (We may have to introduce _efivar_entry_get_locked() to avoid deadlock.)
> 
> I think it is a final bug report related to this new API patch.

Can you try the 'efi-for-tip-fixes' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

and see if your problems are solved?

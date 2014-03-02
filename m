Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029AbaCBX5i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 18:57:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47923 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbaCBX5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 18:57:36 -0500
Message-ID: <5313C54D.3020603@zytor.com>
Date: Sun, 02 Mar 2014 15:57:01 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: "H. Peter Anvin" <hpa@linux.intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, Len.Brown@intel.com,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [patch] x86: Introduce BOOT_EFI and BOOT_CF9 into the reboot
 sequence loop
References: <53110977.8080907@linux.intel.com> <53121496.8060603@linux.intel.com> <20140301172256.GA29417@srcf.ucam.org> <53123DCF.7040500@zytor.com> <20140301202139.GA9759@srcf.ucam.org> <ec95d575-070f-4c62-8b27-3ce281cb192e@email.android.com> <53127AA7.8040700@linux.intel.com> <53127C4B.1060505@zytor.com> <53128DA0.9060105@linux.intel.com> <53129256.6060704@zytor.com> <20140302022334.GA1131@srcf.ucam.org> <c4f4929e-6bab-45b9-ac6b-cbdea5fd57e8@email.android.com> <53130A46.1010801@linux.intel.com> <cfbdc582-9fc0-4335-9974-d508c2da1c71@email.android.com> <5313AD1B.6050403@linux.intel.com>
In-Reply-To: <5313AD1B.6050403@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 02:13 PM, Li, Aubrey wrote:
> 
> No really. Given that we add all of the known methods into the default
> list, and BIOS is the last method, if your system hits BIOS, that means
> ACPI/KBD/EFI/PCI can't make your system reboot, so BIOS should make it
> work.
> 

Or it means the KBD port had delayed effects -- this is the really ugly one.

But yes, I suspect that sequence is the best that we can currently come
up with...

	-hpa



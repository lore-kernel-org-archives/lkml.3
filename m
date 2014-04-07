Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821AbaDGVEN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 17:04:13 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58852 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754572AbaDGVEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 17:04:11 -0400
Message-ID: <53431296.10502@zytor.com>
Date: Mon, 07 Apr 2014 14:03:18 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, rostedt@goodmis.org, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org,
        Adam Williamson <awilliam@redhat.com>
Subject: Re: [tip:x86/reboot] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
References: <20140404064120.GB11877@gmail.com>	<tip-d122ab8d224a59aa0c3e4ba3540c6ab99556c3e3@git.kernel.org>	<20140404080006.GB6944@gmail.com>	<533EB5F1.8060002@linux.intel.com>	<20140404151359.GB12370@srcf.ucam.org> <20140406184023.1e31412d@alan.etchedpixels.co.uk> <53419F84.2090204@zytor.com> <53425B2A.10001@linux.intel.com>
In-Reply-To: <53425B2A.10001@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/2014 01:00 AM, Li, Aubrey wrote:
> 
> EFI is no question. So, Is everybody okay with the following sequence?
> (1) ACPI
> (2) KEYBOARD
> (3) ACPI
> (4) KEYBOARD
> (ADD_1) EFI
> (5) TRIPLE
> (ADD_2) CF9
> (ADD_3) BIOS
> 

No.  Because after "triple" there is NOTHING.  Putting anything after it
is a joke.

How many times do I have to explain this to how many people?  If
"triple" or "BIOS" doesn't work, there is no trying again... the machine
is dead.

	-hpa



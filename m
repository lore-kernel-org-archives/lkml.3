Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751152Ab3EaE06 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 00:26:58 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:43517 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750788Ab3EaE0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 00:26:53 -0400
X-Sasl-enc: exONko62d1QzFCAq2EYCPuIz7czdbVO7n4wR2vEbxoCE 1369974411
Date: Fri, 31 May 2013 01:26:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jacob Shin <jacob.shin@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86@kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 4/4] microcode/x86/amd: early microcode patch loading
 support for AMD
Message-ID: <20130531042649.GA4488@khazad-dum.debian.net>
References: <1369940959-2077-1-git-send-email-jacob.shin@amd.com>
 <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369940959-2077-5-git-send-email-jacob.shin@amd.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 May 2013, Jacob Shin wrote:
>  mkdir initrd
>  cd initrd
> -mkdir kernel
> -mkdir kernel/x86
> -mkdir kernel/x86/microcode
> -cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin
> -find .|cpio -oc >../ucode.cpio
> +mkdir -p kernel/x86/microcode
> +cp ../microcode.bin kernel/x86/microcode/GenuineIntel.bin (or AuthenticAMD.bin)

Can I just 
'cat /lib/firmware/amd-ucode/*bin >kernel/x86/microcode/AuthenticAMD.bin' 
to get a valid microcode container for all amd processors?

The answer for Intel is "yes".  I sure hope it is the same for AMD...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

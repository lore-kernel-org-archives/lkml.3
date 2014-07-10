Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaGJSaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 14:30:11 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54957 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751021AbaGJSaJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 14:30:09 -0400
Date: Thu, 10 Jul 2014 20:30:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: "Luck, Tony" <tony.luck@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
Message-ID: <20140710183001.GD5603@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
 <1404925766-32253-4-git-send-email-hskinnemoen@google.com>
 <3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
 <CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
 <20140710162419.GK2970@pd.tnic>
 <CAFQmdRb-qENEhFrEeNzvBrMuBjusZcxvhanTuzL9VmKncv-1Tg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAFQmdRb-qENEhFrEeNzvBrMuBjusZcxvhanTuzL9VmKncv-1Tg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 10:56:05AM -0700, Havard Skinnemoen wrote:
> Even on kexec-enabled kernels, we might be doing a regular BIOS boot.
> Is there any way to detect that we're doing a kexec boot and only
> clearing the MSRs in that case?

What Tony said: if the processor resets, those MSRs are cleared, forget
BIOS.

I dunno though whether the processor gets reset during kexec though. It
needs code staring...

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

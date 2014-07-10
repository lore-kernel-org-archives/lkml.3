Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaGJQdc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 12:33:32 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:38131 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778AbaGJQdb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 12:33:31 -0400
MIME-Version: 1.0
In-Reply-To: <20140710162419.GK2970@pd.tnic>
References: <1404925766-32253-1-git-send-email-hskinnemoen@google.com>
	<1404925766-32253-4-git-send-email-hskinnemoen@google.com>
	<3908561D78D1C84285E8C5FCA982C28F32857499@ORSMSX114.amr.corp.intel.com>
	<CAFQmdRYabFy84FxeJGbrdd6w5O0mu9Kn_jE5V4rpw7cBrMvb0w@mail.gmail.com>
	<20140710162419.GK2970@pd.tnic>
Date: Thu, 10 Jul 2014 09:33:30 -0700
Message-ID: <CA+8MBbJL6F3pvjX3a0eCNbutuKNudbLeMTbTdz+ZXZ2OOhX-KA@mail.gmail.com>
Subject: Re: [PATCH 3/6] x86-mce: Clear CMCI enable on all claimed CMCI banks
 before reboot.
From: Tony Luck <tony.luck@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Havard Skinnemoen <hskinnemoen@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ewout van Bekkum <ewout@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 10, 2014 at 9:24 AM, Borislav Petkov <bp@alien8.de> wrote:
> I'm saying that because I'm assuming BIOS will clear those MSRs upon
> warm reset. If it doesn't, then we have a bigger problem.

We  don't have to trust BIOS to do that. SDM section 15.3.2.5
"IA32_MCi_CTL2 MSRs" says:

After processor reset, IA32_MCi_CTL2 MSRs are zero’ed.

-Tony

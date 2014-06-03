Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458AbaFCKx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 06:53:57 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:65414 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338AbaFCKx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 06:53:56 -0400
Date: Tue, 3 Jun 2014 13:53:50 +0300
From: Muli Ben-Yehuda <mulix@mulix.org>
To: Jun Koi <junkoi2004@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        "qemu-devel@nongnu.org" <qemu-devel@nongnu.org>
Subject: Re: [Qemu-devel] Nested KVM is weird?
Message-ID: <20140603105350.GA9296@needle>
References: <CA+g7VZ3kFEGjeiQLnoK4GFAYU4=Y-4HU1gzz15A-sCO406qekQ@mail.gmail.com>
 <20140601105927.GD2385@needle>
 <CA+g7VZ05M3NV11A1c4tsnAuBCdvdnirOk-==s2rP1MrrpU909g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+g7VZ05M3NV11A1c4tsnAuBCdvdnirOk-==s2rP1MrrpU909g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 11:30:02PM +0700, Jun Koi wrote:

> (1) do you think this VM_EXIT_LOAD_IA32_PERF_GLOBAL_CTRL is the
>     reason why ESXi falls back to binary translation?

It might be, its been a while since I got ESXi to use VMX on KVM. Take
a look at the VMware log file for the L2, it should have a lot more
information.

Cheers,
Muli

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754861AbaHOGIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 02:08:22 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47493 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729AbaHOGIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 02:08:20 -0400
Date: Fri, 15 Aug 2014 08:07:55 +0200
From: Borislav Petkov <bp@alien8.de>
To: Wanpeng Li <wanpeng.li@linux.intel.com>
Cc: hpa@zytor.com, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, x86@kernel.org,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Jan Kiszka <jan.kiszka@siemens.com>, Toshi Kani <toshi.kani@hp.com>,
        linux-kernel@vger.kernel.org, Zhang Yang <yang.z.zhang@intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linn Crosetto <linn@hp.com>
Subject: Re: [PATCH v4] x86, hotplug: fix llc shared map unreleased during
 cpu hotplug
Message-ID: <20140815060755.GA24362@pd.tnic>
References: <1406625883-4972-1-git-send-email-wanpeng.li@linux.intel.com>
 <20140808224057.GA9288@oranje.fc.hp.com>
 <20140815030042.GA14928@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140815030042.GA14928@kernel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 15, 2014 at 11:00:42AM +0800, Wanpeng Li wrote:
> Is it ok for you to apply this patch or still need update?

Just be patient: we have the merge window still open and after that
kernel summit coming up first.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

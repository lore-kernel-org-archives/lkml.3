Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751693AbaGVAxW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 20:53:22 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51161 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750800AbaGVAxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 20:53:20 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        Robert Moore <robert.moore@intel.com>
Subject: Re: [RFC PATCH v3 00/14] ACPI/EC: Add event storm prevention and cleanup command storm prevention.
Date: Tue, 22 Jul 2014 03:11:42 +0200
Message-ID: <9698076.0kdZ11M3j2@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1405922585.git.lv.zheng@intel.com>
References: <cover.1403060601.git.lv.zheng@intel.com> <cover.1405922585.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 21, 2014 02:04:51 PM Lv Zheng wrote:
> Note that this patchset is very stable now, it is sent as RFC because it
> depends on an ACPICA GPE enhancement series which might be merged from
> ACPICA upstream.

Do I remember correctly that this is the plan?

So I'm expecting to receive the Linux versions of the relevant ACPICA changes
from you and then I'll apply this material on top of them.

We don't need to wait for the next ACPICA release with this I think, but
I'd like the GPE changes to be applied to upstream ACPICA at least before
I get them.

Rafael


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751187AbaKXFcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 00:32:05 -0500
Received: from pegasus3.altlinux.org ([194.107.17.103]:56420 "EHLO
	pegasus3.altlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbaKXFcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 00:32:01 -0500
X-Greylist: delayed 481 seconds by postgrey-1.27 at vger.kernel.org; Mon, 24 Nov 2014 00:32:00 EST
Date: Mon, 24 Nov 2014 08:23:57 +0300
From: Michael Shigorin <mike@altlinux.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net, lenb@kernel.org,
        wsa@the-dreams.de, robert.moore@intel.com, lv.zheng@intel.com,
        shigorin@gmail.com, adamw@happyassassin.net, jan.brummer@tabos.org,
        mika.westerberg@linux.intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        devel@acpica.org
Subject: Re: [PATCH V3] ACPI: Add _DEP(Operation Region Dependencies) support to fix battery issue on the Asus T100TA
Message-ID: <20141124052357.GL18607@imap.altlinux.org>
Mail-Followup-To: "Li, Aubrey" <aubrey.li@linux.intel.com>,
	Lan Tianyu <tianyu.lan@intel.com>, rjw@rjwysocki.net,
	lenb@kernel.org, wsa@the-dreams.de, robert.moore@intel.com,
	lv.zheng@intel.com, shigorin@gmail.com, adamw@happyassassin.net,
	jan.brummer@tabos.org, mika.westerberg@linux.intel.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-i2c@vger.kernel.org, devel@acpica.org
References: <1416748974-24124-1-git-send-email-tianyu.lan@intel.com> <54729A7B.4050007@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54729A7B.4050007@linux.intel.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:39:55AM +0800, Li, Aubrey wrote:
> Well, Can we explicitly tied this up with ASUS T100TA in the code?

It works for me on Aava Inari 8 too.

-- 
š---- WBR, Michael Shigorin / http://altlinux.org
šš------ http://opennet.ru / http://anna-news.info

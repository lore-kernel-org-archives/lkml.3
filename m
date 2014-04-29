Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247AbaD2VVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 17:21:30 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58672 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755045AbaD2VV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 17:21:27 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Adam Williamson <awilliam@redhat.com>, Lan Tianyu <tianyu.lan@intel.com>,
        mika.westerberg@linux.intel.com, lenb@kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Lv Zheng <lv.zheng@intel.com>
Subject: Re: [Patch V2 1/9] ACPICA: Executer: Fix buffer allocation issue for generic_serial_bus region field accesses.
Date: Tue, 29 Apr 2014 23:37:57 +0200
Message-ID: <3011387.grhlkC2GdR@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140429113128.GA3640@katana>
References: <1398147855-9868-1-git-send-email-tianyu.lan@intel.com> <8704550.LJW911OU1k@vostro.rjw.lan> <20140429113128.GA3640@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2014 01:31:28 PM Wolfram Sang wrote:
> 
> --3MwIy2ne0vdjdPXF
> Content-Type: text/plain; charset=us-ascii
> Content-Disposition: inline
> 
> 
> > The rest has been queued up for 3.16.
> 
> I also aim for 3.16, yet it may take 1 or 2 weeks more until I'll be
> able to review the I2C part of those patches.

That's fine, they can stay in my bleeding-edge branch till then.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.

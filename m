Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaJSVJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 17:09:30 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:55338 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaJSVJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 17:09:29 -0400
MIME-Version: 1.0
In-Reply-To: <20141016160358.GB12979@intel.com>
References: <1413372916-12091-1-git-send-email-jarkko.sakkinen@linux.intel.com>
	<1413372916-12091-5-git-send-email-jarkko.sakkinen@linux.intel.com>
	<20141016093146.GA25070@kroah.com>
	<20141016160358.GB12979@intel.com>
Date: Mon, 20 Oct 2014 00:09:27 +0300
Message-ID: <CA+i0qc4XgqF4c+TcyXvPG6XFs_LNvWWRs8p_=-iGeD_bQU9Zpw@mail.gmail.com>
Subject: Re: [PATCH v3 4/6] tpm: TPM 2.0 sysfs attributes
From: Tomas Winkler <tomasw@gmail.com>
To: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, Peter Huewe <peterhuewe@gmx.de>,
        Ashley Lai <ashley@ashleylai.com>,
        Marcel Selhorst <tpmdd@selhorst.net>,
        tpmdd-devel@lists.sourceforge.net,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-api@vger.kernel.org, josh.triplett@intel.com,
        christophe.ricard@gmail.com, will.c.arthur@intel.com,
        monty.wiseman@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Here the options are limited because misc_register already spawns
> KOBJ_ADD. Not much to do unless we would wipe the current use of
> misc driver completely.

I would strongly recommend to drop the misc layer here, as tpm itself
can provide the needed abstraction for the devices.

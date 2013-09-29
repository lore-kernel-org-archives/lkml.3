Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab3I2WlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 18:41:23 -0400
Received: from imap.thunk.org ([74.207.234.97]:39990 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab3I2WlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 18:41:21 -0400
Date: Sun, 29 Sep 2013 18:41:06 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Workaround missing pci_set_master in pci drivers
Message-ID: <20130929224106.GA19331@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Yinghai Lu <yinghai@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
References: <CAE9FiQV8ipnQ_vV68S-QHMrUrQTWQT_XObxyBeR=dOuw6fG1eg@mail.gmail.com>
 <1380399187-4962-1-git-send-email-yinghai@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380399187-4962-1-git-send-email-yinghai@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 28, 2013 at 01:13:07PM -0700, Yinghai Lu wrote:
> Fixed by add checking in pci_enable_bridge, and call pci_set_master
> if driver skip that.
> That will make the code more robot and wade off problem for missing
> pci_set_master in drivers.

Petty spelling nit; feel free to ignore unless you need to respin the
patch anyway....

s/robot/robost/

Cheers,

						- Ted

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab3J2Leg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:34:36 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36344 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3J2Led (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:34:33 -0400
Date: Tue, 29 Oct 2013 07:34:14 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Veaceslav Falico <vfalico@redhat.com>
Cc: linux-pci@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, yinghai@kernel.org, Knut_Petersen@t-online.de,
        mingo@kernel.org, paulmck@linux.vnet.ibm.com, fweisbec@gmail.com,
        linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 2/3] pci: remove redundant pci_dev_get/put() on
 kobject (un)register
Message-ID: <20131029113414.GC24477@neilslaptop.think-freely.org>
References: <1383042632-7102-1-git-send-email-vfalico@redhat.com>
 <1383042632-7102-3-git-send-email-vfalico@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383042632-7102-3-git-send-email-vfalico@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 11:30:31AM +0100, Veaceslav Falico wrote:
> Currently we're pci_dev_get/put()-ing pci device on every kobject
> creation/removal. It's useless per se - the kobject is part of the device
> itself, so it should be removed when there are no users of the pdev, and is
> not a user of it.
> 
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Neil Horman <nhorman@tuxdriver.com>
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: linux-pci@vger.kernel.org
> CC: linux-kernel@vger.kernel.org
> Signed-off-by: Veaceslav Falico <vfalico@redhat.com>
Acked-by: Neil Horman <nhorman@tuxdriver.com>

> 

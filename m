Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab3KYXC1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 18:02:27 -0500
Received: from mga09.intel.com ([134.134.136.24]:56755 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab3KYXCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 18:02:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,770,1378882800"; 
   d="scan'208";a="441676655"
Date: Mon, 25 Nov 2013 15:02:20 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joe Mario <jmario@redhat.com>
Subject: Re: [PATCH 1/2] PCI: Do not use PCI ID macros in quirk names
Message-ID: <20131125230220.GH19762@tassilo.jf.intel.com>
References: <1384177236-8371-1-git-send-email-mmarek@suse.cz>
 <5281E97D.6090806@suse.cz>
 <CAErSpo6sCvDuSA3Bw0LY7D6QYC=xhPP05f966kjDP0mvqu5wEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6sCvDuSA3Bw0LY7D6QYC=xhPP05f966kjDP0mvqu5wEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's LTO?  I guess it's Link Time Optimization?  Is there any

Yes. Link Time Optimization with modern gcc.

> documentation about how it works or how to use it?

It's still a separate tree, but bits'n'pieces are slowly
making it into the kernel.

https://github.com/andikleen/linux-misc/tree/lto-3.12

https://github.com/andikleen/linux-misc/blob/5a18e33264321b01816a220ab14207a5f26ae16e/Documentation/lto-build

http://halobates.de/kernel-lto.pdf

-Andi

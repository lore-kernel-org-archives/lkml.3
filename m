Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757819AbaE2Qax (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:30:53 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:38647 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757449AbaE2Qat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:30:49 -0400
Date: Thu, 29 May 2014 10:30:37 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kumar Gala <galak@codeaurora.org>
Cc: Liviu Dudau <liviu@dudau.co.uk>, Kishon Vijay Abraham I <kishon@ti.com>,
        devicetree <devicetree@vger.kernel.org>, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>,
        tony@atomide.com, Mohit Kumar <mohit.kumar@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be
 specified in 'reg'
Message-ID: <20140529163037.GC2552@obsidianresearch.com>
References: <1401345500-20188-1-git-send-email-kishon@ti.com>
 <1401345500-20188-4-git-send-email-kishon@ti.com>
 <98E18225-3C63-4106-901A-A5D3DEC268C8@codeaurora.org>
 <20140529151840.GD1677@bart.dudau.co.uk>
 <CF1BAF3F-E16E-4864-8052-8C3EC29000B0@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CF1BAF3F-E16E-4864-8052-8C3EC29000B0@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 11:03:36AM -0500, Kumar Gala wrote:

> Just because the kernel doesn’t handle this is NO reason to change
> the way the DT works.

The OF specs do not specify how to process a config type ranges entry,
and we all mutually agreed that the only sane interpretation for such
a thing would be to describe an ECAM memory space so generic code
could potentially make use of it.

Since designware is not ECAM it should not use config ranges.

This has come up multiple times now, and the above is the consensus.

Jason

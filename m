Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbaE2QvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:51:13 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:50882 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932790AbaE2QvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:51:07 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.2 \(1874\))
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should be specified in 'reg'
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20140529163037.GC2552@obsidianresearch.com>
Date: Thu, 29 May 2014 11:51:00 -0500
Cc: Marek Vasut <marex@denx.de>, Liviu Dudau <liviu@dudau.co.uk>,
        Jingoo Han <jg1.han@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        devicetree <devicetree@vger.kernel.org>, tony@atomide.com,
        linux-pci@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kishon Vijay Abraham I <kishon@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Transfer-Encoding: 8BIT
Message-Id: <A9B853EE-65C6-4B2E-ABC0-1E64DE584E91@codeaurora.org>
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-4-git-send-email-kishon@ti.com> <98E18225-3C63-4106-901A-A5D3DEC268C8@codeaurora.org> <20140529151840.GD1677@bart.dudau.co.uk> <CF1BAF3F-E16E-4864-8052-8C3EC29000B0@codeaurora.org> <20140529163037.GC2552@obsidianresearch.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
X-Mailer: Apple Mail (2.1874)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 29, 2014, at 11:30 AM, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:

> On Thu, May 29, 2014 at 11:03:36AM -0500, Kumar Gala wrote:
> 
>> Just because the kernel doesn’t handle this is NO reason to change
>> the way the DT works.
> 
> The OF specs do not specify how to process a config type ranges entry,
> and we all mutually agreed that the only sane interpretation for such
> a thing would be to describe an ECAM memory space so generic code
> could potentially make use of it.
> 
> Since designware is not ECAM it should not use config ranges.
> 
> This has come up multiple times now, and the above is the consensus.
> 
> Jason

Well the designware controller does support ECAM, just that the current in kernel users don’t do cfg space that way.

So do we continue to support the current users that use a cfg range for a non-ECAM space?  Or break their DT and convert them to using regs?

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation


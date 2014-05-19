Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbaESQcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:32:31 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:41182 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932356AbaESQc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:32:29 -0400
Date: Mon, 19 May 2014 17:32:23 +0100
From: Will Deacon <will.deacon@arm.com>
To: Srikanth Thokala <sthokal@xilinx.com>
Cc: "bhelgaas@google.com" <bhelgaas@google.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "michals@xilinx.com" <michals@xilinx.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH] PCI: Generic Configuration Access Mechanism support
Message-ID: <20140519163223.GP15130@arm.com>
References: <1400422125-2209-1-git-send-email-sthokal@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400422125-2209-1-git-send-email-sthokal@xilinx.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 18, 2014 at 03:08:45PM +0100, Srikanth Thokala wrote:
> This patch adds support for a generic CAM and ECAM configuration
> space accesses.

Looks good to me, thanks Srikanth!

Arnd: is this the sort of thing you were expecting? The
->is_valid_cfg_access callback is a bit horrible, but I can't think of
anything better.

I can include this in the next posting of my PCI patches.

Will

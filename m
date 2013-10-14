Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755666Ab3JNKbG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:31:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:53672 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753797Ab3JNKbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:31:04 -0400
Date: Mon, 14 Oct 2013 12:30:53 +0200
From: Borislav Petkov <bp@alien8.de>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 4/8] DMI: Parse memory device (type 17) in SMBIOS
Message-ID: <20131014103053.GD4009@pd.tnic>
References: <1381473166-29303-1-git-send-email-gong.chen@linux.intel.com>
 <1381473166-29303-5-git-send-email-gong.chen@linux.intel.com>
 <20131011154048.GH5925@pd.tnic>
 <20131014032113.GB12189@gchen.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131014032113.GB12189@gchen.bj.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 13, 2013 at 11:21:13PM -0400, Chen Gong wrote:
> Yes, but we highly expect BIOS manufactors to make is valid and
> complete.

Well, you can always do sanity checks with FW_BUG noisy printks. I don't
see any other way to move fw vendors - simply expecting them is not an
incentive enough, IMO. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

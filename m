Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab3GAWtV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 18:49:21 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54907 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab3GAWtT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 18:49:19 -0400
Date: Tue, 2 Jul 2013 00:49:11 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, ananth@in.ibm.com, masbock@linux.vnet.ibm.com,
        lcm@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, ying.huang@intel.com
Subject: Re: [PATCH v3 2/3] mce: acpi/apei: Add a boot option to disable ff
 mode for corrected errors
Message-ID: <20130701224911.GN23515@pd.tnic>
References: <20130701153728.6197.14022.stgit@localhost.localdomain>
 <20130701153854.6197.76602.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130701153854.6197.76602.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01, 2013 at 09:08:54PM +0530, Naveen N. Rao wrote:
> Add a boot option to disable firmware first mode for corrected errors.
> 
> 
> Signed-off-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

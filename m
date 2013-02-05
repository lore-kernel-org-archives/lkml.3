Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3BEQzn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:55:43 -0500
Received: from tundra.namei.org ([65.99.196.166]:46072 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753878Ab3BEQzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:55:40 -0500
Date: Wed, 6 Feb 2013 03:49:11 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kent Yoder <key@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, peterhuewe@gmx.de,
        mathias.leblanc@st.com, jgunthorpe@obsidianresearch.com
Subject: Re: [PULL] tpm drivers: STM i2c driver, documentation and fixes
In-Reply-To: <20130205154821.GA15966@ennui.austin.ibm.com>
Message-ID: <alpine.LRH.2.02.1302060348530.5022@tundra.namei.org>
References: <20130205154821.GA15966@ennui.austin.ibm.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013, Kent Yoder wrote:

> Hi James,
> 
> The following changes since commit 0d2a1b2d03dfd5ee79e7ebc59635690c8f08810f:
> 
>   mpilib: use DIV_ROUND_UP and remove unused macros (2013-02-01 16:28:32 +1100)
> 
> are available in the git repository at:
> 
>   git://github.com/shpedoikal/linux.git tpmdd-02-05-13
> 
> for you to fetch changes up to 6e38bfaad6c83bdd07eb659f9bfd50f8d71a5a46:
> 
>   tpm_tis: check pnp_acpi_device return code (2013-02-05 09:38:26 -0600)
> 


Thanks, applied.


-- 
James Morris
<jmorris@namei.org>

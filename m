Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752370AbaE0Jkd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 05:40:33 -0400
Received: from mail.skyhub.de ([78.46.96.112]:59357 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319AbaE0Jk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 05:40:27 -0400
Date: Tue, 27 May 2014 11:40:24 +0200
From: Borislav Petkov <bp@alien8.de>
To: Daniel Walter <dwalter@google.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, richard@nod.at,
        x86-ml <x86@kernel.org>
Subject: Re: [PATCH 09/12] [arch/x86] Remove obsolete strict_strto calls
Message-ID: <20140527094024.GA4366@pd.tnic>
References: <20140526221333.GK25779@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140526221333.GK25779@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 26, 2014 at 11:13:33PM +0100, Daniel Walter wrote:
> From: Daniel Walter <dwalter@google.com>
> Subject: [PATCH 09/12] [arch/x86] replace strict_strto calls
> 
> Replace obsolete strict_strto calls with appropriate kstrto calls
> 
> Signed-off-by: Daniel Walter <dwalter@google.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

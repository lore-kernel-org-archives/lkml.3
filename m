Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753942Ab3LBXUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 18:20:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:48322 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab3LBXUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 18:20:48 -0500
Date: Tue, 3 Dec 2013 00:20:43 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "'Doug Thompson'" <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 07/39] edac: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131202232043.GF7380@pd.tnic>
References: <001501ceefb1$69c96820$3d5c3860$%han@samsung.com>
 <001c01ceefb3$5724d860$056e8920$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <001c01ceefb3$5724d860$056e8920$%han@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 03, 2013 at 08:07:57AM +0900, Jingoo Han wrote:
> Don't use DEFINE_PCI_DEVICE_TABLE macro, because this macro
> is not preferred.

Says who and why?

The author of the commit message (that is you) should explain to the
onlooker (that is me) why this patch needs to be applied.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

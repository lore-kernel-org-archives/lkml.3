Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3LFJZe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 04:25:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45429 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757141Ab3LFJZa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 04:25:30 -0500
Date: Fri, 6 Dec 2013 10:25:27 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "'Doug Thompson'" <dougthompson@xmission.com>,
        linux-edac@vger.kernel.org
Subject: Re: [PATCH 07/39] edac: remove DEFINE_PCI_DEVICE_TABLE macro
Message-ID: <20131206092527.GB6181@pd.tnic>
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
> 
> Signed-off-by: Jingoo Han <jg1.han@samsung.com>

Applied, thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

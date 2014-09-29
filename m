Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754816AbaI2V6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 17:58:09 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:33544 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI2V6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 17:58:07 -0400
Date: Mon, 29 Sep 2014 23:58:04 +0200
From: Andreas Mohr <andi@lisas.de>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: alsa-devel@alsa-project.org, Andreas Mohr <andi@lisas.de>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] ES938 support for ES18xx driver
Message-ID: <20140929215804.GA20023@rhlx01.hs-esslingen.de>
References: <1412027079-15876-1-git-send-email-linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412027079-15876-1-git-send-email-linux@rainbow-software.org>
X-Priority: none
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 11:44:39PM +0200, Ondrej Zary wrote:
> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> ---
> Changes in v3:
>  - constify buf argument to snd_rawmidi_kernel_write
>  - remove double if from probe
>  - spelling fix
> Changes in v2:
>  - debug message when ES938 detected
>  - reworked sysex messages to use structs
>  - ktime instead of jiffies for timeout
> ---

Nice!

Reviewed-by: Andreas Mohr <andim2@users.sf.net>

Andreas Mohr

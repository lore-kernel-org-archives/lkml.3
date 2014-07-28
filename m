Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818AbaG1O0n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 10:26:43 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50153 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaG1O0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 10:26:42 -0400
Date: Mon, 28 Jul 2014 16:26:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 6/8] x86, microcode, intel: total_size is valid only when
 data_size != 0
Message-ID: <20140728142640.GB5350@pd.tnic>
References: <1406146251-8540-1-git-send-email-hmh@hmh.eng.br>
 <1406146251-8540-7-git-send-email-hmh@hmh.eng.br>
 <20140725164614.GE4421@pd.tnic>
 <20140725190411.GA21416@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20140725190411.GA21416@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2014 at 04:04:11PM -0300, Henrique de Moraes Holschuh wrote:
> As far as I can tell, Intel has always filled the reserved fields in the
> microcode data files with zeros.

Yes, and this is the statement I was looking for. IF(!) this really
is the case, then we don't have anything to worry about because new
kernel with old container will look at ->datasize, see 0 and return
DEFAULT_UCODE_TOTALSIZE and we're fine.

I've updated the patch with your additional explanation.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932207AbaIRQUL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 12:20:11 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.216]:25360 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756440AbaIRQUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 12:20:09 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWi/zfN1cLnBYfstVolSR8Cl8fNabDQrlSrQo8jPq2gOVbkBPuE3yQ==
X-RZG-CLASS-ID: mo00
Date: Thu, 18 Sep 2014 18:20:04 +0200
From: Olaf Hering <olaf@aepfle.de>
To: "K. Y. Srinivasan" <kys@microsoft.com>, hch@infradead.org
Cc: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/1] Drivers: scsi: storvsc: Get rid of warning messages
Message-ID: <20140918162004.GA18124@aepfle.de>
References: <1409701396-20226-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1409701396-20226-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 02, K. Y. Srinivasan wrote:

> Get rid of the warning messages since they will clutter up various system logs
> and are of questionable value to the end user. For debugging purposes, this
> information can be gotten by setting the scsi log level appropriately.
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Reviewed-by: Olaf Hering <olaf@aepfle.de>

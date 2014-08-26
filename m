Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934340AbaHZJZ1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 05:25:27 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:40292 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407AbaHZJZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 05:25:26 -0400
Date: Tue, 26 Aug 2014 10:25:21 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: "Arnout Vandecappelle (Essensium/Mind)" <arnout@mind.be>,
        Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        David Brown <davidb@codeaurora.org>
Subject: Re: [PATCH v2] tps65910: Work around silicon erratum SWCZ010
Message-ID: <20140826092521.GH9574@lee--X1>
References: <1408709666-5927-1-git-send-email-arnout@mind.be>
 <1408721456-8101-1-git-send-email-arnout@mind.be>
 <20140822211247.GB24407@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140822211247.GB24407@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014, Mark Brown wrote:

> On Fri, Aug 22, 2014 at 05:30:56PM +0200, Arnout Vandecappelle (Essensium/Mind) wrote:
> > From http://www.ti.com/lit/pdf/SWCZ010 :
> > 
> > Glitch on SDA-SCL not managed correctly by the I2C IP

 drivers/mfd/tps65910.c | 5 +++++
 1 file changed, 5 insertions(+)

> Applied, thanks.

Eh?

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

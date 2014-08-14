Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754507AbaHNStg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 14:49:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48731 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978AbaHNStd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 14:49:33 -0400
Date: Thu, 14 Aug 2014 20:49:30 +0200
From: Pavel Machek <pavel@denx.de>
To: tthayer@opensource.altera.com
Cc: robherring2@gmail.com, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        linux@arm.linux.org.uk, atull@opensource.altera.com,
        delicious.quinoa@gmail.com, dinguyen@opensource.altera.com,
        dougthompson@xmission.com, grant.likely@linaro.org, bp@alien8.de,
        sameo@linux.intel.com, lee.jones@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, tthayer.linux@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Subject: Re: [PATCHv10 1/2] edac: altera: Add Altera SDRAM EDAC support.
Message-ID: <20140814184930.GB11558@amd.pavel.ucw.cz>
References: <1407770293-27190-1-git-send-email-tthayer@opensource.altera.com>
 <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407770293-27190-2-git-send-email-tthayer@opensource.altera.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2014-08-11 10:18:12, tthayer@opensource.altera.com wrote:
> From: Thor Thayer <tthayer@opensource.altera.com>
> 
> This patch adds support for the CycloneV and ArriaV SDRAM controllers.
> Correction and reporting of SBEs, Panic on DBEs.
> 
> Signed-off-by: Thor Thayer <tthayer@opensource.altera.com>

Acked-by: Pavel Machek <pavel@denx.de>

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html

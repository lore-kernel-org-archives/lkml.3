Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758105AbaEPRwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 13:52:51 -0400
Received: from mx1.emlix.com ([88.198.240.195]:50000 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756948AbaEPRwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 13:52:49 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 May 2014 13:52:49 EDT
Date: Fri, 16 May 2014 19:46:20 +0200
From: Daniel =?iso-8859-1?Q?Gl=F6ckner?= <dg@emlix.com>
To: "Zhu, Lejun" <lejun.zhu@linux.intel.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com, linux-kernel@vger.kernel.org,
        linux-gpio@vger.kernel.org, bin.yang@intel.com
Subject: Re: gpio: Add support for Intel SoC PMIC (Crystal Cove)
Message-ID: <20140516174619.GA1471@emlix.com>
References: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1400082247-24168-1-git-send-email-lejun.zhu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Organization: emlix gmbh, Goettingen, Germany
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lejun,

On Wed, May 14, 2014 at 11:44:07PM +0800, Zhu, Lejun wrote:
> This patch adds support for the GPIO function in Crystal Cove.

in our device ACPI makes use of "virtual" GPIOs that have numbers from
0x20 to 0x5E to change various bits in the PMIC. Do you know if this
is officially supported by the INT33FD ACPI device or if it is a
vendor hack?

  Daniel


-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11,
Bertha-von-Suttner-Straße 9, 37085 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführung: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner

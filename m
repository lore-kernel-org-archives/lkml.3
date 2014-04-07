Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaDGBe7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 21:34:59 -0400
Received: from mo4-p05-ob.smtp.rzone.de ([81.169.146.183]:14903 "EHLO
	mo4-p05-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076AbaDGBey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 21:34:54 -0400
X-RZG-AUTH: :OmsBZ2C7d7IBoB6EHwegNiNxh/xpjMmBYR0YjlTttojRtSoTz+DSIfqHRQ==
X-RZG-CLASS-ID: mo05
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: driverdev-devel@linuxdriverproject.org
Subject: Re: [PATCH] staging: rtl8187se: Fix warning symbol should be static
Date: Mon, 7 Apr 2014 01:34:42 +0000
User-Agent: KMail/1.13.7 (Linux/3.14-0.slh.1-aptosid-686; KDE/4.8.4; i686; ; )
Cc: Josh Triplett <josh@joshtriplett.org>, Jonas Hahnfeld <hahnjo@hahnjo.de>,
        devel@driverdev.osuosl.org,
        "Andreea-Cristina Bernat" <bernat.ada@gmail.com>,
        Andrea Merello <andrea.merello@gmail.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Ana Rey <anarey@gmail.com>, linux-kernel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>,
        Dan LaManna <dan.lamanna@gmail.com>,
        Pablo Neira Ayuso <pablo@gnumonks.org>
References: <1396799183-7412-1-git-send-email-hahnjo@hahnjo.de> <20140406160903.GA8114@leaf>
In-Reply-To: <20140406160903.GA8114@leaf>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201404070134.46030.s.L-H@gmx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Sunday 06 April 2014, Josh Triplett wrote:
> On Sun, Apr 06, 2014 at 05:46:04PM +0200, Jonas Hahnfeld wrote:
> > This patch solves some sparse warnings about "symbol [...] was not
> > declared. Should it be static?" by including the correct header files.
> > 
> > Signed-off-by: Jonas Hahnfeld <hahnjo@hahnjo.de>
> 
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
[...]

Given that that rtl8187se support has already been merged mainline (for
3.15-rc1) into the existing rtl8180 (soon to be renamed to rtl818x) 
driver, wouldn't it make more sense to remove 
drivers/staging/rtl8187se/ rather than trying to fixing it?

commit 1eba648f998ef9c31b8cf062754a4a7b4ab9001f
Author: Andrea Merello <andrea.merello@gmail.com>
Date:   Wed Mar 26 21:04:23 2014 +0100

    rtl8180: enable rtl8187se support
    
    Finally make rtl8187se works (hopefylly).
    This patch adds PCI ID for rtl8187, updates copyright notes and
    updates MODULE_DESCRIPTION.
    
    Signed-off-by: Andrea Merello <andrea.merello@gmail.com>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

Regards
	Stefan Lippers-Hollmann

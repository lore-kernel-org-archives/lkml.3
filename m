Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935287AbaGRVYh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 17:24:37 -0400
Received: from mail.skyhub.de ([78.46.96.112]:47887 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932218AbaGRVYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 17:24:36 -0400
Date: Fri, 18 Jul 2014 23:24:27 +0200
From: Borislav Petkov <bp@alien8.de>
To: Conrad Kostecki <ck@conrad-kostecki.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Early microcode not being loaded
Message-ID: <20140718212427.GB11098@pd.tnic>
References: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <d01572d84b834e9d98aef338f7da446a@DB4PR04MB265.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 08:40:42PM +0000, Conrad Kostecki wrote:
> Where is the problem? Why is the microcode not being loaded early?

CONFIG_MICROCODE_INTEL_EARLY=y set in .config?

You can also try with a recent distro kernel and initrd which has
microcode in it to rule out you're doing something wrong when generating
the initrd.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

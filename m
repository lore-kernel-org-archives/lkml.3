Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaCIRJA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:09:00 -0400
Received: from mail-qa0-f47.google.com ([209.85.216.47]:56908 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaCIRI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:08:59 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20140309114134.502cdcae7e6a97db684d6b15@kernel.org>
References: <20140309114134.502cdcae7e6a97db684d6b15@kernel.org>
Date: Sun, 9 Mar 2014 10:08:58 -0700
Message-ID: <CAOesGMhUVEEa6KLs2ZORxJunxitVdOQ5-wbs3KtEWBq+77t5JA@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 9, 2014 at 4:41 AM, Mark Brown <broonie@kernel.org> wrote:
> Hi all,
>
> After merging the arm-soc tree, today's linux-next build (20140309)
> failed for multi_v7_defconfig like this:
>
> ERROR (phandle_references): Reference to non-existent node or label "sysmgr"
>
> ERROR (phandle_references): Reference to non-existent node or label "sysmgr"
>
> ERROR: Input tree has errors, aborting (use -f to force output)
> make[2]: *** [arch/arm/boot/dts/socfpga_arria5_socdk.dtb] Error 2

Known issue, I unmerged the offending branch but didn't push out the
backed out for-next branch last night (I was unaware that you were
doing linux-next now, and sfr doesn't do them until Sunday night our
time, so I didn't think it was urgent).



-Olof

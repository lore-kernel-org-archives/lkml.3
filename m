Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab3GWQ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 12:58:22 -0400
Received: from smtp1.uu.se ([130.238.7.54]:48501 "EHLO smtp1.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932705Ab3GWQ6V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 12:58:21 -0400
X-Spam-Flag: NO
X-Spam-Score: -3.835
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20974.46422.436937.172719@pilspetsen.it.uu.se>
Date: Tue, 23 Jul 2013 18:54:46 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: =?ISO-8859-1?Q?Ortwin_Gl=FCck?= <odi@odi.ch>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_X86_PKG_TEMP_THERMAL causes #GP fault on Core i7-740QM
 breaking boot
In-Reply-To: <51EEA665.2050209@odi.ch>
References: <51EEA665.2050209@odi.ch>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ortwin Glück writes:
 > Hi,
 > 
 > I think the bug is already fixed in this commit:
 > 
 > f3ed0a17f0292300b3caca32d823ecd32554a667
 > 
 > Thermal: x86 package temp thermal crash

Thanks.  Although I can see that patch in git, it's NOT present in either
the linux-3.11-rc2.tar.xz or the patch-3.11-rc2.xz files.  Which is strange
since the patch was committed 8 days ago, and -rc2 was released 2 days ago.

I'm assuming there was a mistake when preparing this -rc2 snapshot, but if
the -rc3 snapshot also differs from git I'll alert Linus.

/Mikael

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab3CRPzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 11:55:03 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51014 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3CRPzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 11:55:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] arm-soc fixes for v3.9-rc3
Date: Mon, 18 Mar 2013 15:54:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <201303181422.14942.arnd@arndb.de> <CA+55aFx9NF-+dt5r_hOpUfZxd6Ky+OBL2echeeM50ZE6UAaAdA@mail.gmail.com>
In-Reply-To: <CA+55aFx9NF-+dt5r_hOpUfZxd6Ky+OBL2echeeM50ZE6UAaAdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303181554.55853.arnd@arndb.de>
X-Provags-ID: V02:K0:cDTrYYGDrns5RNfYDXMjzUgg5q5xNhnqQDfWTlSnHyn
 75zJipUicVsLdkx/R2pdDTyN5AX0EHCx95h1/s4EqIBX0RxtV3
 Xo6l/P19z6QSc39AgXQGiiRkf1ZXY+9I/x+zEkIrpWZVo98+bP
 9vU+pGzNHuGpLJ5L3Vui0N9FNz+8q4pWp+5LhGYCcr/kqCDF0A
 wh53jPgLEW+IrPB+bMB9m2KYY6KjC1tZgzXAeoAZhMVplOKH8X
 kUr2iDnDgmJwhvLgXfWSn2GPp2loHwg7qcg00/4pI7I+IDCZOY
 bFYkPcJWOccUZUk/fbSX2XGS7pcMVxmIbcgD28XPf8fE7u6hBL
 iSEV/niSoIHW1Lz71zNo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 March 2013, Linus Torvalds wrote:
> On Mon, Mar 18, 2013 at 7:22 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > are available in the git repository at:
> >
> >   git+ssh://gitolite@ra.kernel.org/pub/scm/linux/kernel/git/arm/arm-soc.git tags/fixes
> 
> What the heck happened to your script?
> 
> Please use the public address so that others could look at it if they
> want to (and so that my merge messages make sense in a public
> setting).
> 
> I fixed it up, but please fix your script for next time.

Thanks for fixing it up, it was no script this time, but a manual copy-paste
mistake. git-request-pull got confused by the fact I had commits both before
and after -rc2 in the branch, and was listing lots of changes that you had
already merged in the list, so I tried to construct the output in the
way that was supposed to look, and failed.

	Arnd

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758632Ab3EFVkl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 17:40:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51544 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991Ab3EFVkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 17:40:40 -0400
Date: Mon, 6 May 2013 23:40:37 +0200
From: Michal Marek <mmarek@suse.cz>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "SamuelOrtiz@kroah.com" <SamuelOrtiz@kroah.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-kbuild <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] Fix cleaning in scripts/mod
Message-ID: <20130506214037.GA25934@pobox.suse.cz>
References: <51814943.7000604@intel.com> <20130501182138.GA17550@kroah.com> <5B8DA87D05A7694D9FA63FD143655C1B01F18E66@HASMSX106.ger.corp.intel.com> <518284E6.7040503@intel.com> <CAMuHMdWSVUcwkY=xn+HjbruLxsc8Eqq=CWX78CdUc1+MAwCVhg@mail.gmail.com> <87sj22zuga.fsf_-_@hase.home> <CAMuHMdX6PETQqQG-ASDv4OtLyB=X0hNyQRaSO13rUHf_HqNt3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX6PETQqQG-ASDv4OtLyB=X0hNyQRaSO13rUHf_HqNt3w@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 05, 2013 at 10:24:43AM +0200, Geert Uytterhoeven wrote:
> On Sat, May 4, 2013 at 4:32 PM, Andreas Schwab <schwab@linux-m68k.org> wrote:
> > Make sure devicetable-offsets.h is cleaned in the scripts/mod directory
> >
> > Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
> 
> Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

Applied to kbuild.git#kbuild.

Michal

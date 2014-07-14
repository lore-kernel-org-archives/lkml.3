Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054AbaGNPfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 11:35:20 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58366 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755900AbaGNPfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 11:35:16 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-arch <linux-arch@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Michal Marek <mmarek@suse.cz>,
        David Howells <dhowells@redhat.com>
Subject: Re: [RFC PATCH 0/38] clean-up uapi + asm-generic Kbuild files
Date: Mon, 14 Jul 2014 17:34:59 +0200
Message-ID: <8199537.GiECsdyhzt@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140714150609.GA28358@ravnborg.org>
References: <20140714150609.GA28358@ravnborg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:5P7vr+DuS8ShrBEub8vCqg107v54+cTpnrxuCz9fkD0
 W2v5gL4aR1LASiomLjzowdjQgP6GutCXDnt+teI+Me0W8bhoow
 Mw9YPqdgdKSdvNqZ4KogiUnq7zkOgqyl/ePfdoALXr6/byJZn4
 zP5wd0arkcx+1LsG8h/Ohaw7ah+Ot3RIZI66zy/FZZHT7G1OHD
 +G0IzbZfAyU5yXrXc/fcPWsgK9kOvZUW/dEbuc9mqaN3GuLtGP
 u1g062M53RyXMDL01TSJe8EJR2VIaCrDwr0m5L3ktrMLYypFrs
 iAn1Frzr/R4lvB74B0OKpAS7hEG6v0KyymEvm65tYpLhnVrMB4
 hhKzLcaEnw3nNMCt+qRM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 14 July 2014 17:06:09 Sam Ravnborg wrote:
> 
> What tree is the best for this stuff?
> I would suggest to go via the asm-generic tree that Arnd has.
> But it also touches a lot of architectures so Andrews -mm or
> kbuild#misc could be used.

I rarely have anything to send for the asm-generic tree, usually I
rely on things getting merged the other way round, through whoever
has an interest in changing asm-generic.

	Arnd

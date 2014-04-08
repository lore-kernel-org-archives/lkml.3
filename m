Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaDHQVX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 12:21:23 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:36071 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756643AbaDHQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 12:21:21 -0400
Date: Tue, 8 Apr 2014 17:19:29 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Borislav Petkov <bp@alien8.de>
Cc: Christopher Covington <cov@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Courtney Cavin <courtney.cavin@sonymobile.com>
Subject: Re: [PATCH v6 2/5] ARM: Add Krait L2 register accessor functions
Message-ID: <20140408171929.68f328a9@alan.etchedpixels.co.uk>
In-Reply-To: <20140408151056.GH30077@pd.tnic>
References: <1396641450-12854-1-git-send-email-sboyd@codeaurora.org>
	<1396641450-12854-3-git-send-email-sboyd@codeaurora.org>
	<20140407201838.GC20822@pd.tnic>
	<20140407215649.GH9985@codeaurora.org>
	<20140408064328.GB30077@pd.tnic>
	<534406BD.8000702@codeaurora.org>
	<20140408151056.GH30077@pd.tnic>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Apr 2014 17:10:56 +0200
Borislav Petkov <bp@alien8.de> wrote:

> On Tue, Apr 08, 2014 at 10:25:01AM -0400, Christopher Covington wrote:
> > As I understand it, the license authors. They find it important to maintain
> > clarity even when files get copied into other projects.
> > 
> > http://www.gnu.org/licenses/gpl-howto.html
> > 
> > http://www.gnu.org/licenses/gpl-faq.html#NoticeInSourceFile
> 
> Right, so what is wrong with stating the same thing in two lines:
> 
> "Copyright (c) 2011-2013, The Linux Foundation. All rights reserved.
> 
> This file is licensed under GNU GPLv2. See COPYING for full license text.

The COPYING file may not be present. There may be cases where the absence
of the warranty statement in the header is problematic etc etc.

Corporate legals have their own policies on this and there is no point
fighting them because

- they are the ones qualified to make the decision

- the corporate legal angle is often "do this or don't release it"

- we have huge numbers of files using that same no warranty in every
  file, and major companies who specify it must be present in their code
  releases


Including the without warranty is standard practice at a lot of
companies. It's not even wasting space - it'll compress beautifully as
there are already lots of similar headers all over the tree.

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752110AbaIVA6b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 20:58:31 -0400
Received: from one.firstfloor.org ([193.170.194.197]:50581 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194AbaIVA6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 20:58:30 -0400
Date: Mon, 22 Sep 2014 02:58:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>
Subject: Re: x86, microcode: BUG: microcode update that changes
 x86_capability
Message-ID: <20140922005827.GH4120@two.firstfloor.org>
References: <20140918135202.GA26038@khazad-dum.debian.net>
 <87tx40h4mz.fsf@tassilo.jf.intel.com>
 <06e07006-342a-4041-8592-37dd16866be6@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <06e07006-342a-4041-8592-37dd16866be6@email.android.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 05:51:12PM -0700, H. Peter Anvin wrote:
> He said *outside* of the early update mechanism.

True. Sorry yes I misread it.

Yes, that's the way to go.

-Andi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755491Ab3CFVN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 16:13:56 -0500
Received: from longford.logfs.org ([213.229.74.203]:58616 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478Ab3CFVNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 16:13:55 -0500
Date: Wed, 6 Mar 2013 14:49:50 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0/9] Add blockconsole version 1.1 (try 2)
Message-ID: <20130306194950.GA19938@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <s5htxovxcrl.wl%tiwai@suse.de>
 <20130301162239.GC16393@logfs.org>
 <s5hy5e1u4t2.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hy5e1u4t2.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 March 2013 18:36:41 +0100, Takashi Iwai wrote:
> 
> Another thing I noticed is that the panic handler calls bcon_write(),
> and it doesn't write to the device by itself.  Is it really supposed
> to work?

Clearly it is supposed to work.  In reality it sometimes does and
sometimes does not.  Patches to improve the success rate are welcome.

> Meanwhile I hacked the code to allow it being built as a module.
> If anyone is interested, I'll send a patch series.  It's pretty
> hackish, so likely need more brush up, though.

I am interested.

Jörn

--
Ninety percent of everything is crap.
-- Sturgeon's Law

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab3CARzS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:55:18 -0500
Received: from longford.logfs.org ([213.229.74.203]:58598 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751100Ab3CARzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:55:16 -0500
Date: Fri, 1 Mar 2013 11:31:28 -0500
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/9] blockconsole: use CON_ALLDATA
Message-ID: <20130301163128.GA16713@logfs.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-6-git-send-email-joern@logfs.org>
 <x49txov14mp.fsf@segfault.boston.devel.redhat.com>
 <20130301162029.GB16393@logfs.org>
 <20130301175220.GF30938@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130301175220.GF30938@pd.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 March 2013 18:52:20 +0100, Borislav Petkov wrote:
> On Fri, Mar 01, 2013 at 11:20:29AM -0500, Jörn Engel wrote:
> > If you and/or other people are strongly opposed to the CON_ALLDATA
> > patches, I can either keep them private (we will never drop them from
> > our kernel) or add a config option.
> 
> We'll do that when someone comes up with a really persuasive reason why
> blockconsole shouldn't log *all* messages. And, whatever we do, I don't
> want to configure/set anything so that blockconsole logs everything - it
> should be the default.

For blockconsole I agree.  Netconsole is the interesting one, because
CON_ALLDATA could be considered a regression for it.

Jörn

--
The key to performance is elegance, not battalions of special cases.
-- Jon Bentley and Doug McIlroy

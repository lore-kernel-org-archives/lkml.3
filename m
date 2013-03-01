Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3CAR5G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 12:57:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:35810 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab3CAR5E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 12:57:04 -0500
Date: Fri, 1 Mar 2013 18:56:53 +0100
From: Borislav Petkov <bp@alien8.de>
To: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 5/9] blockconsole: use CON_ALLDATA
Message-ID: <20130301175653.GG30938@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	=?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>,
	Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
References: <1362087602-8979-1-git-send-email-joern@logfs.org>
 <1362087602-8979-6-git-send-email-joern@logfs.org>
 <x49txov14mp.fsf@segfault.boston.devel.redhat.com>
 <20130301162029.GB16393@logfs.org>
 <20130301175220.GF30938@pd.tnic>
 <20130301163128.GA16713@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130301163128.GA16713@logfs.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 11:31:28AM -0500, Jörn Engel wrote:
> For blockconsole I agree.  Netconsole is the interesting one, because
> CON_ALLDATA could be considered a regression for it.

Yeah, that's why I suggested dropping 4/9 - nothing changes for
netconsole so that everyone can relax :-).

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

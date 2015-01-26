Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbbAZN2i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 08:28:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221AbbAZN2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 08:28:36 -0500
Date: Mon, 26 Jan 2015 14:28:34 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: KY Srinivasan <kys@microsoft.com>
cc: Nicholas Mc Guire <der.herr@hofr.at>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match wait_for_completion_timeout
 return type
In-Reply-To: <BY2PR0301MB07116F48FBCAC922CD8A33E3A0340@BY2PR0301MB0711.namprd03.prod.outlook.com>
Message-ID: <alpine.LNX.2.00.1501261427490.10817@pobox.suse.cz>
References: <1422197267-8001-1-git-send-email-der.herr@hofr.at> <BY2PR0301MB07116F48FBCAC922CD8A33E3A0340@BY2PR0301MB0711.namprd03.prod.outlook.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 25 Jan 2015, KY Srinivasan wrote:

> > Subject: [PATCH 3/3 v2] hyperv: hid-hyperv.c: match
> > wait_for_completion_timeout return type
> > 
> > Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>
> 
> Thank you.
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>

Applied. Nicholas, please make sure that next time you format the 
changelog properly (whatever goes after '---' is normally ignored).

-- 
Jiri Kosina
SUSE Labs

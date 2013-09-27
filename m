Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835Ab3I0MuL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:50:11 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751574Ab3I0MuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:50:05 -0400
Date: Fri, 27 Sep 2013 14:49:25 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Kernel Fedora <kernel@lists.fedoraproject.org>
Subject: Re: Fedora Kernel Patch Report
In-Reply-To: <52336AF5.3040104@zytor.com>
Message-ID: <alpine.LRH.2.00.1309271449100.8203@twin.jikos.cz>
References: <CA+5PVA7Y-r67u7K5R5XJOEcyCmyTe9Q8fJNQr=6-i1n6QitrPA@mail.gmail.com> <52336AF5.3040104@zytor.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Sep 2013, H. Peter Anvin wrote:

> > crash-driver.patch
> >   - The patch to add /dev/crash.  Dave Anderson keeps making this work (mostly).
> > 
> 
> It is also a security hole.

More than /dev/[k]mem? How so?

-- 
Jiri Kosina
SUSE Labs


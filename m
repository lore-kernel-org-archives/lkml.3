Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762019Ab3EDSvY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 14:51:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46578 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758096Ab3EDSvW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 14:51:22 -0400
Date: Sat, 4 May 2013 19:51:17 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Sam Creasey <sammy@sammy.net>, scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next 2/2] sun3_scsi: switch to ->show_info()
Message-ID: <20130504185117.GF25399@ZenIV.linux.org.uk>
References: <1365594729-25759-1-git-send-email-geert@linux-m68k.org>
 <1365594729-25759-2-git-send-email-geert@linux-m68k.org>
 <CAMuHMdWEMT8FWaByiBh+Y2qhwWyqT4JyVZmLsCEYv30v2qM4yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdWEMT8FWaByiBh+Y2qhwWyqT4JyVZmLsCEYv30v2qM4yg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:03:43PM +0200, Geert Uytterhoeven wrote:
> Ping?
> 
> Now the build failure is also in Linus' tree:
> 
> http://kisskb.ellerman.id.au/kisskb/buildresult/8674437/
> 
> BTW, this patch depends on "[PATCH 1/2] sun3_scsi: Fill in missing
> scsi_host_template.proc_info method"

Collapsed together and applied, will go out today

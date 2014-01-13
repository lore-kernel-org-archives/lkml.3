Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751719AbaAMMkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 07:40:36 -0500
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:38750 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaAMMkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 07:40:31 -0500
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+yackYocTD1iAi8x+OWMTlsoxCss+iCqhAw1vkA==
X-RZG-CLASS-ID: mo00
Date: Mon, 13 Jan 2014 13:40:29 +0100
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: david.vrabel@citrix.com, xen-devel@lists.xen.org,
        boris.ostrovsky@oracle.com, konrad.wilk@oracle.com,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH v2] xen-blkfront: remove type check from
 blkfront_setup_discard
Message-ID: <20140113124029.GA19027@aepfle.de>
References: <1389608052-7139-1-git-send-email-olaf@aepfle.de>
 <52D3DAEE0200007800112FD4@nat28.tlf.novell.com>
 <20140113120131.GA15623@aepfle.de>
 <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52D3EB5F02000078001130B5@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.22.rev6346 (2013-10-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, Jan Beulich wrote:

> >>> On 13.01.14 at 13:01, Olaf Hering <olaf@aepfle.de> wrote:
> > On Mon, Jan 13, Jan Beulich wrote:
> > 
> >> You can't do this in one go - the first two and the last one may be
> >> set independently (and are independent in their meaning), and
> >> hence need to be queried independently (xenbus_gather() fails
> >> on the first absent value).
> > 
> > Yes, thats the purpose. Since the properties are required its an all or
> > nothing thing. If they are truly optional then blkif.h should be updated
> > to say that.
> 
> They _are_ optional.

In this case my first patch is correct and should be used.

Olaf

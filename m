Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbbABSvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 13:51:51 -0500
Received: from mail-wg0-f49.google.com ([74.125.82.49]:57531 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbbABSvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 13:51:49 -0500
Date: Fri, 2 Jan 2015 19:51:44 +0100
From: Richard Cochran <richardcochran@gmail.com>
To: Laurent Georget <laurent.georget@supelec.fr>
Cc: Jeff Epler <jepler@unpythonic.net>, linux-man <linux-man@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Subject: Re: [PATCH] adjtimex: PPM scaling is by 2^-16
Message-ID: <20150102185144.GB4206@localhost.localdomain>
References: <54A2DEAD.2050708@supelec.fr>
 <20150102024118.GA8293@unpythonic.net>
 <20150102062920.GB4221@localhost.localdomain>
 <54A6C9B5.4050904@supelec.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54A6C9B5.4050904@supelec.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2015 at 05:39:17PM +0100, Laurent Georget wrote:
> Ah, ok, I finally understood what you meant by "fractional part".
> Perhaps we could explicit it in the man page like in the following patch?

Much improved. Looks good to me.

Thanks,
Richard

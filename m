Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965324AbaGRQIJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 12:08:09 -0400
Received: from asavdk3.altibox.net ([109.247.116.14]:35747 "EHLO
	asavdk3.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761707AbaGRQII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 12:08:08 -0400
Date: Fri, 18 Jul 2014 18:08:03 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Khalid Aziz <khalid.aziz@oracle.com>
Cc: davem@davemloft.net, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] sparc: Add support for seek and shorter read to
 /dev/mdesc
Message-ID: <20140718160802.GA21385@ravnborg.org>
References: <1405696541-25189-1-git-send-email-khalid.aziz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405696541-25189-1-git-send-email-khalid.aziz@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2014 at 09:15:40AM -0600, Khalid Aziz wrote:
> /dev/mdesc on Linux does not support reading arbitrary number
> of bytes and seeking while /dev/mdesc on Solaris does. This
> causes tools that work on Solaris to break on Linux. This patch
> adds these two capabilities to /dev/mdesc.
> 
> Signed-off-by: Khalid Aziz <khalid.aziz@oracle.com>
Acked-by: Sam Ravnborg <sam@ravnborg.org>

Thanks,
	Sam

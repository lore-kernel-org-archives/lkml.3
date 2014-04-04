Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbaDDLLg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 07:11:36 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33629 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752520AbaDDLLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 07:11:34 -0400
Date: Fri, 4 Apr 2014 14:11:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Mike Sampson <mike@sambodata.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Andreas Dilger <andreas.dilger@intel.com>,
        Kees Cook <keescook@chromium.org>, Peng Tao <bergwolf@gmail.com>,
        linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Staging: lustre: mark a variable static in workitem.c
Message-ID: <20140404111117.GU6991@mwanda>
References: <533e73d6.a642420a.707f.ffffa00d@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <533e73d6.a642420a.707f.ffffa00d@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 04, 2014 at 07:22:25PM +1100, Mike Sampson wrote:
> next-20140403: This fixes a sparse warning:
  ^^^^^^^^^^^^^

Just leave this out.  Either it applies when Greg gets around to it, or
you'll have to redo it.  If you want to add this information then put it
directly after the --- cut off line so it doesn't show up in the
permanent commit log.

The subject should have a [PATCH v2] because this is a second version.

After the --- write:
---
v2: updated the changelog

regards,
dan carpenter


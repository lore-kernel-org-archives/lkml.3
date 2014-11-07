Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751431AbaKGJx7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 04:53:59 -0500
Received: from mga03.intel.com ([134.134.136.65]:19749 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750974AbaKGJxy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 04:53:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="485352119"
Message-ID: <1415354030.958.304.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/4] UBIFS: add xattr support for security / SELinux
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ben Shelton <ben.shelton@ni.com>
Cc: linux-mtd@lists.infradead.org, adrian.hunter@intel.com,
        linux-kernel@vger.kernel.org
Date: Fri, 07 Nov 2014 11:53:50 +0200
In-Reply-To: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
References: <1414781431-2911-1-git-send-email-ben.shelton@ni.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-31 at 13:50 -0500, Ben Shelton wrote:
> I'm reposting the patch series for security xattr / SELinux support on UBIFS
> from Subodh Nijsure and Marc Kleine-Budde [1] in order to restart the process
> of getting this support upstream.
> 
> Notes:
> 
>  - I removed 'UBIFS: xattr: protect ui_size and data_len by ui_mutex' because
>    after looking through the comments before the definition of struct
>    ubifs_inode, I'm not sure what this was intended to fix.  It looks like
>    i_size and data_len are not intended to be protected by ui_mutex, and I'm
>    unclear on why ui->ui_size needs to be protected here by host_ui's ui_mutex.
>    CCing Marc -- could you comment on how this is supposed to work?

Thanks, I'll be looking at this as time allows. I think the MTD web site
mentioned somewhere that SELinux is not supported or something. In any
case, once we support SELinux, we need to tell on the web site that we
support it.

Which reminds me that I need to update the web-site and tell there that
I do not support the backport trees any longer...


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756563Ab3AQNMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 08:12:40 -0500
Received: from smtp.eu.citrix.com ([46.33.159.39]:37484 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3AQNMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 08:12:39 -0500
X-IronPort-AV: E=Sophos;i="4.84,486,1355097600"; 
   d="scan'208";a="722635"
Message-ID: <1358428356.13856.55.camel@zakaz.uk.xensource.com>
Subject: Re: [Xen-devel] [PATCH] xen/grant-table: Force to use v1 of grants.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "annie.li@oracle.com" <annie.li@oracle.com>,
        "msw@amazon.com" <msw@amazon.com>
Date: Thu, 17 Jan 2013 13:12:36 +0000
In-Reply-To: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
References: <1358371369-19089-1-git-send-email-konrad.wilk@oracle.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-16 at 21:22 +0000, Konrad Rzeszutek Wilk wrote:
> Note: The hypervisor provides an over-ride for the default
> of 32 frames (pages) per guest: gnttab_max_nr_frames=X

Should we consider increasing this value?

Ian.


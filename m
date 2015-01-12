Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753069AbbALN3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 08:29:44 -0500
Received: from mga09.intel.com ([134.134.136.24]:43808 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752111AbbALN3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 08:29:42 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,744,1413270000"; 
   d="scan'208";a="649813365"
Message-ID: <1421069367.31978.21.camel@linux.intel.com>
Subject: Re: [PATCH] gpu:drm:Change calls to mdelay to msleep in the
 functions,send_pkg_prepare and send_pkg_done for the
 file,mdfld_dsi_pkg_sender.c
From: Alan Cox <alan@linux.intel.com>
To: Nicholas Krause <xerofoify@gmail.com>
Cc: airlied@linux.ie, airlied@redhat.com, damien.lespiau@intel.com,
        treding@nvidia.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Date: Mon, 12 Jan 2015 13:29:27 +0000
In-Reply-To: <1420950664-18875-1-git-send-email-xerofoify@gmail.com>
References: <1420950664-18875-1-git-send-email-xerofoify@gmail.com>
Organization: Intel Corporation
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9 (3.12.9-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2015-01-10 at 23:31 -0500, Nicholas Krause wrote:
> Changes various calls in the functions,send_pkg_prepare and send_pkg_done
> for mdelay to msleep. These changes are needed due to use working with
> various sleep modes supported by this hardware and thus needing to sleep
> for a small duration instead of using the respectful delay function due
> to the need to sleep rather then busy loop the CPU(s) and waste CPU cycles
> on the system that could be used to handle other tasks.
> 
> Signed-off-by: Nicholas Krause <xerofoify@gmail.com>

NAK

Like every other TODO you've been mucking with at random this one is
there for a reason.

We can't sleep at this point.



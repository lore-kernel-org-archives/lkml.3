Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092AbaKGLuv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 06:50:51 -0500
Received: from mga01.intel.com ([192.55.52.88]:55648 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbaKGLus (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 06:50:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,331,1413270000"; 
   d="scan'208";a="628267061"
Message-ID: <1415361043.958.326.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: Fix double free after do_sync_erase()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Fri, 07 Nov 2014 13:50:43 +0200
In-Reply-To: <1415288869-14915-1-git-send-email-richard@nod.at>
References: <1415288869-14915-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-06 at 16:47 +0100, Richard Weinberger wrote:
> If the erase worker is unable to erase a PEB it will
> free the ubi_wl_entry itself.
> The failing ubi_wl_entry must not free()'d again after
> do_sync_erase() returns.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed, thanks!



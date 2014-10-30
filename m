Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758352AbaJ3Izz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:55:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:52404 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753923AbaJ3Izx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:55:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,284,1413270000"; 
   d="scan'208";a="628175921"
Message-ID: <1414659349.23185.27.camel@sauron.fi.intel.com>
Subject: Re: [PATCH] UBI: vtbl: Use ubi_eba_atomic_leb_change()
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 30 Oct 2014 10:55:49 +0200
In-Reply-To: <1414259021-5691-1-git-send-email-richard@nod.at>
References: <1414259021-5691-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-10-25 at 19:43 +0200, Richard Weinberger wrote:
> This is more a cosmetic change than a fix.
> By using ubi_eba_atomic_leb_change()
> we can guarantee that the first VTBL record is always
> correct and we don't really need the second one anymore.
> But we have to keep the second one to not break anything.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Yeah, this atomic change stuff was added later, and we had not
envisioned originally. Your patch adds robustness, but makes volume
creation slower, which is probably not a problem.

I've added a small comment and pushed it, thanks!

Artem


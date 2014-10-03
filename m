Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223AbaJCOiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 10:38:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:14955 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbaJCOiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 10:38:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="609269873"
Message-ID: <1412347098.3795.63.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/4] UBI: Fastmap: Calc fastmap size correctly
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Fri, 03 Oct 2014 17:38:18 +0300
In-Reply-To: <1412029248-22454-3-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-3-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
> We need to add fm_sb too.
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Pushed this one, thank you!


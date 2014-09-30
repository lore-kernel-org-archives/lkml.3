Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaI3G0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 02:26:11 -0400
Received: from mga01.intel.com ([192.55.52.88]:34695 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751873AbaI3G0J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 02:26:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,625,1406617200"; 
   d="scan'208";a="598620066"
Message-ID: <1412058366.23429.77.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 1/4] UBI: Ensure that all fastmap work is done upon WL
 shutdown
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Tue, 30 Sep 2014 09:26:06 +0300
In-Reply-To: <1412029248-22454-2-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
	 <1412029248-22454-2-git-send-email-richard@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-30 at 00:20 +0200, Richard Weinberger wrote:
> ...otherwise the deferred work might run after datastructures
> got freed and corrupt memory.

How can this happend? The background thread is stopped by this time
already, so what are the other possibilities? And why is this
fastmap-only?

-- 
Best Regards,
Artem Bityutskiy


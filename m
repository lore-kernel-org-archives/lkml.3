Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756910Ab3CYKcN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 06:32:13 -0400
Received: from mga01.intel.com ([192.55.52.88]:12430 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755660Ab3CYKcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 06:32:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="311494174"
From: Andi Kleen <andi@firstfloor.org>
To: Christian Schmidt <schmidt@digadd.de>
Cc: dm-crypt@saout.de, linux-kernel@vger.kernel.org
Subject: Re: kworkers for dm-crypt locked to CPU core 0?
References: <51501C0A.5060406@digadd.de>
Date: Mon, 25 Mar 2013 03:32:11 -0700
In-Reply-To: <51501C0A.5060406@digadd.de> (Christian Schmidt's message of
	"Mon, 25 Mar 2013 10:42:34 +0100")
Message-ID: <m2obe7ixck.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Schmidt <schmidt@digadd.de> writes:
>
> Is there a way I can make the scheduler put those on multiple cores?

Submit the IO from multiple cores. Don't use dd.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only

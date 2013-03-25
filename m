Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756870Ab3CYD6p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 23:58:45 -0400
Received: from mga01.intel.com ([192.55.52.88]:12364 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755693Ab3CYD6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 23:58:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,902,1355126400"; 
   d="scan'208";a="311365886"
Date: Mon, 25 Mar 2013 12:08:05 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, htejun@gmail.com, ming.lei@canonical.com,
        sshtylyov@mvista.com, lpechacek@suse.cz, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, seth.heasley@intel.com, jlee@suse.com,
        james.d.ralston@intel.com, stable@vger.kernel.org,
        youquan.song@intel.com
Subject: Re: [PATCH v3] ata: Fix DVD not dectected at some Haswell platforms
Message-ID: <20130325160805.GA16882@linux-youquan.bj.intel.com>
References: <1362584945-10202-1-git-send-email-youquan.song@intel.com> <20130314140123.GA19289@linux-youquan.bj.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130314140123.GA19289@linux-youquan.bj.intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Can you look at the patch which required by some Haswell platforms?
> 
Hi Jeff,

What's your opinion about the patch? It block the installation on some
new platforms.

Thanks
-Youquan 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758841AbaGSJXk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:23:40 -0400
Received: from mga11.intel.com ([192.55.52.93]:64529 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959AbaGSJXi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:23:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,690,1400050800"; 
   d="scan'208";a="572262495"
Message-ID: <1405761815.28207.15.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 5/5] fs/ubifs/{sb,super}.c: drop negativity check on
 unsigned value
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Andrey Utkin <andrey.krieger.utkin@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, dcb314@hotmail.com,
        adrian.hunter@intel.com
Date: Sat, 19 Jul 2014 12:23:35 +0300
In-Reply-To: <1405697725-23866-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405697725-23866-1-git-send-email-andrey.krieger.utkin@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-07-18 at 18:35 +0300, Andrey Utkin wrote:
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80581
> Reported-by: David Binderman <dcb314@hotmail.com>
> Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>

Hi, thanks, but I already have a patch which does the same in the
linux-ubifs.git tree:

commit b793a8c8885d87d9867fb2dbfdc1ef7b5877d71b
Author: hujianyang <hujianyang@huawei.com>
Date:   Wed Jun 11 10:42:52 2014 +0800

    UBIFS: remove useless statements
    
    This patch removes useless and duplicate statements.
    
    Signed-off-by: hujianyang <hujianyang@huawei.com>
    Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

-- 
Best Regards,
Artem Bityutskiy



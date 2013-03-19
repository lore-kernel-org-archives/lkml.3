Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab3CSCiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 22:38:01 -0400
Received: from mga01.intel.com ([192.55.52.88]:54845 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756115Ab3CSCh6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 22:37:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,868,1355126400"; 
   d="scan'208";a="304815924"
Date: Tue, 19 Mar 2013 10:47:09 -0400
From: Youquan Song <youquan.song@linux.intel.com>
To: Sergio Correia <lists@uece.net>
Cc: Youquan Song <youquan.song@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@kernel.org
Subject: Re: [PATCH] x86,apic: Blacklist x2APIC on some platforms
Message-ID: <20130319144709.GA29206@linux-youquan.bj.intel.com>
References: <1355850450-26445-1-git-send-email-youquan.song@intel.com> <50D0A8CE.7040704@linux.intel.com> <CAE9FiQUfCOip_dJM9gTVsiXH5iHHPzTsnp=sBz2ughMJh1HT8Q@mail.gmail.com> <20130105145519.GB32169@linux-youquan.bj.intel.com> <CAJyhjX1HbxzfDv963Zi_CJ703P=by+hVdsHhNrH3HrnFvz8amQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJyhjX1HbxzfDv963Zi_CJ703P=by+hVdsHhNrH3HrnFvz8amQ@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> I found this patch after some googling and for the record, it makes my
> W520 boot with VT-d enabled and the discrete NVidia card.
> Is it still being considered?
> 

Yes.  I am still in pushing the patch to upstream. The patch is good and reviewed
by Yinghai but it depends on Yinghai's patch which is not upstream now.
http://git.kernel.org/cgit/linux/kernel/git/yinghai/linux-yinghai.git/diff/?id=de38757e964cfee20e6da1977572a2191d7f4aa0

Refer to https://bugzilla.kernel.org/show_bug.cgi?id=43054

Peter, will you take it?

Thanks
-Youquan


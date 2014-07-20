Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbaGTSF1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 14:05:27 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:51817 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaGTSF0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 14:05:26 -0400
Date: Sun, 20 Jul 2014 20:01:17 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Ethan Zhao <ethan.kernel@gmail.com>
Cc: Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Ethan Zhao <ethan.zhao@oracle.com>,
        Manish Chopra <manish.chopra@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V3] netxen: fix ethtool rx_dropped information in ethtool
 get_ethtool_stats()
Message-ID: <20140720180117.GA18951@electric-eye.fr.zoreil.com>
References: <1405655009-18975-1-git-send-email-ethan.zhao@oracle.com>
 <C562D0E12CBDE44E8A0CCAB77060096701283AD344@AVMB1.qlogic.org>
 <049BCC6F-0A2E-421A-9873-0B7ED6FFB3AC@gmail.com>
 <20140719101946.GA4319@electric-eye.fr.zoreil.com>
 <CABawtvP4+B_smOyi-=vt56KuUthzHF9L059PXP4ekXA7KPk_Dw@mail.gmail.com>
 <20140719162816.GB7590@electric-eye.fr.zoreil.com>
 <48774298-8C91-42A9-A5F2-4EAB789F356B@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48774298-8C91-42A9-A5F2-4EAB789F356B@gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ethan Zhao <ethan.kernel@gmail.com> :
[...]
> you leave us without a tool to track the net core part. Would you like to
> hack the kernel code and rebuild just for peek the dropping packets ?

Search 'dropwatch' on your favorite engine search.

[...]
> More radically, and maybe you should write patches to fix them to keep
> their focus. That is to prove you have principle and always fight for it.

It's 15 years late but it's still a good advice. :o)

-- 
Ueimor

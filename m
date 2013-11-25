Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754236Ab3KYPMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 10:12:13 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:60300 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab3KYPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 10:12:11 -0500
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Richard Genoud <richard.genoud@gmail.com>, zhouguangming@innofidei.com,
        Hans Zhang <zhanghonghui@innofidei.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
References: <528EB1E3.7030101@innofidei.com> <20131122015237.GB3509@localhost>
	<528EBD0B.5010006@innofidei.com> <20131122114509.GB2414@localhost>
	<5292A7E7.5060003@innofidei.com> <20131125101147.GA2408@localhost>
	<CACQ1gAi26WeiopptcZmBp6h0a5TacLo5mvVCOm6-H_1HtnwvXg@mail.gmail.com>
	<529334D9.2030204@innofidei.com> <20131125115238.GC2408@localhost>
	<1385381770.24518.18.camel@shinybook.infradead.org>
	<20131125123012.GE2408@localhost>
Date: Mon, 25 Nov 2013 16:12:06 +0100
In-Reply-To: <20131125123012.GE2408@localhost> (Ezequiel Garcia's message of
	"Mon, 25 Nov 2013 09:30:13 -0300")
Message-ID: <87fvqkldmh.fsf@dell.be.48ers.dk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Ezequiel" == Ezequiel Garcia <ezequiel.garcia@free-electrons.com> writes:

Hi,

 > Thanks a lot for the insight. After reading this, I'm wondering what's
 > preventing us from killing MTD block support altogether. Artem, already
 > suggested it a while back...

People using squashfs/cramfs/readonly ext2/.. on a NOR flash?

-- 
Bye, Peter Korsgaard

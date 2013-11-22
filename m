Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3KVBwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 20:52:36 -0500
Received: from top.free-electrons.com ([176.31.233.9]:33479 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753021Ab3KVBwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 20:52:34 -0500
Date: Thu, 21 Nov 2013 22:52:38 -0300
From: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
To: Hans Zhang <zhanghonghui@innofidei.com>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        zhouguangming@innofidei.com
Subject: Re: [PATCH] Make the mtdblock read/write skip the bad nand sector
Message-ID: <20131122015237.GB3509@localhost>
References: <1385024065-29965-1-git-send-email-zhanghonghui@innofidei.com>
 <CACQ1gAiLesYEWmHkivAF=t8ekCFM=yDDyzkJTtduavNjp1g6wA@mail.gmail.com>
 <528EB1E3.7030101@innofidei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <528EB1E3.7030101@innofidei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 09:22:43AM +0800, Hans Zhang wrote:
> On 2013/11/21 18:59, Richard Genoud wrote:
> 
> Here's my scenario, I want to write nand through mtdblock by dd command

You could get some better support by explaining why do you want to write
to a NAND through mtdblock. It sounds a bit ackward to me, but I'm sure
you have a good reason for it!

Let's hear it :-)
-- 
Ezequiel García, Free Electrons
Embedded Linux, Kernel and Android Engineering
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932516AbaJNPK2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 11:10:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:48814 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaJNPK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 11:10:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,717,1406617200"; 
   d="scan'208";a="618452223"
Message-ID: <1413299343.7906.103.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v4] mtd: ubi: Extend UBI layer debug/messaging
 capabilities
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, linux-mtd@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        Richard Weinberger <richard@nod.at>,
        open list <linux-kernel@vger.kernel.org>
Date: Tue, 14 Oct 2014 18:09:03 +0300
In-Reply-To: <20141014143902.GA9768@arch.hh.imgtec.org>
References: <1413296037-22346-1-git-send-email-tlinder@codeaurora.org>
	 <20141014143902.GA9768@arch.hh.imgtec.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-14 at 11:39 -0300, Ezequiel Garcia wrote:
> Please use some pr_fmt for this. Something like this before the headers
> should be enough:
> 
> #define pr_fmt(fmt) "UBI: block:" fmt

Sinc ubiblock is a device, there should be a 'struct device' somewhere,
so probably dev_printk() and other dev_*() printing functions would be a
better choice?

--
Artem


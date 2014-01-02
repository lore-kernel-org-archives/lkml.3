Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaABPRA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:17:00 -0500
Received: from mga14.intel.com ([143.182.124.37]:16078 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787AbaABPQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:16:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,591,1384329600"; 
   d="scan'208";a="452767309"
Message-ID: <1388675815.25123.91.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 4/25] UBI: fix error return code
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 02 Jan 2014 17:16:55 +0200
In-Reply-To: <1388357260-4843-5-git-send-email-Julia.Lawall@lip6.fr>
References: <1388357260-4843-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1388357260-4843-5-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-12-29 at 23:47 +0100, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Set the return variable to an error code as done elsewhere in the function.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Pushed to linux-ubifs.git, thanks!

-- 
Best Regards,
Artem Bityutskiy


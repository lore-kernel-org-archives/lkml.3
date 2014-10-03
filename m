Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095AbaJCPie (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:38:34 -0400
Received: from mga11.intel.com ([192.55.52.93]:5025 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753808AbaJCPi3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:38:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,647,1406617200"; 
   d="scan'208";a="600346899"
Message-ID: <1412350705.3795.105.camel@sauron.fi.intel.com>
Subject: Re: [RFC/PATCH 1/5] mtd: ubi: Read disturb infrastructure
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: Tanya Brokhman <tlinder@codeaurora.org>, dedeking1@gmail.com,
        linux-arm-msm@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Date: Fri, 03 Oct 2014 18:38:25 +0300
In-Reply-To: <542D5BC0.5040207@nod.at>
References: <1411886220-8208-1-git-send-email-tlinder@codeaurora.org>
	 <5427C45C.2080506@nod.at> <5427CB6E.7010007@codeaurora.org>
	 <5427CCD8.2090605@nod.at> <5427E6FE.3090906@codeaurora.org>
	 <5427E8CA.8000904@nod.at> <542D49FD.7040204@codeaurora.org>
	 <542D5203.2080601@nod.at> <542D5657.3060208@codeaurora.org>
	 <542D5BC0.5040207@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-02 at 16:05 +0200, Richard Weinberger wrote:
> The question is, do we really need all this values on-flash?

Good question, this is why I requested some kind of design description,
which would clearly explain the problem.

Just off-the top of my head, may be it could be enough to keep the
counters only in the UBI headers, may be it is enough to work with some
kind of averages. But it is hard to tell without clearly understanding
the problem we are solving.



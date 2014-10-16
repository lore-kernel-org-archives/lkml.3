Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbaJPKPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 06:15:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:2477 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765AbaJPKPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 06:15:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,731,1406617200"; 
   d="scan'208";a="606350479"
Message-ID: <1413454534.7906.156.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 3/4] UBI: Fastmap: Care about the protection queue
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 16 Oct 2014 13:15:34 +0300
In-Reply-To: <543F9895.7010502@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
					 <1412029248-22454-4-git-send-email-richard@nod.at>
				 <1412346676.3795.62.camel@sauron.fi.intel.com> <542EF3BF.1070401@nod.at>
			 <1413206263.7906.18.camel@sauron.fi.intel.com> <543BE21F.5020504@nod.at>
		 <1413213803.7906.45.camel@sauron.fi.intel.com> <543C3E60.4080507@nod.at>
	 <1413282203.7906.72.camel@sauron.fi.intel.com> <543F9895.7010502@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-10-16 at 12:06 +0200, Richard Weinberger wrote:
> What I'm trying to say is, state tracking would solve the "internal state accessing" problem in a clean and
> sane way.

Can you squeeze the stat to the lookup talbe? It contains pointers, so
the last 2 bits could be used for the state.


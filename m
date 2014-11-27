Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463AbaK0Qt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:49:56 -0500
Received: from mga09.intel.com ([134.134.136.24]:7467 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780AbaK0Qtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:49:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="490981972"
Message-ID: <1417106992.5858.135.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/6] UBI: Fastmap: Ensure that only one fastmap work is
 scheduled
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 27 Nov 2014 18:49:52 +0200
In-Reply-To: <547753C0.6050604@nod.at>
References: <1416835236-25185-1-git-send-email-richard@nod.at>
			 <1416835236-25185-3-git-send-email-richard@nod.at>
		 <1417102042.5858.102.camel@sauron.fi.intel.com> <54774DB7.5090200@nod.at>
	 <1417106151.5858.122.camel@sauron.fi.intel.com> <547753C0.6050604@nod.at>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-27 at 17:39 +0100, Richard Weinberger wrote:
> > So the background thread would first check this flag, and if it is set -
> > call the fastmap stuff. The go do the WL works.
> > 
> > Just off-the top of my head, take with grain of salt.
> 
> So you want me to redesign it?
> IMHO this is just a matter of taste.
> 
> Face it, my brain does not work like yours. I design things differently.

OK.


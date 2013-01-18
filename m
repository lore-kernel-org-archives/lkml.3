Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751585Ab3ARHXd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 02:23:33 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50489 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751143Ab3ARHXc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 02:23:32 -0500
Date: Fri, 18 Jan 2013 16:23:26 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Jangam <ashish.jangam@kpitcummins.com>
Cc: Liam Girdwood <lrg@ti.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, David Dajun Chen <dchen@diasemi.com>
Subject: Re: [patch v1 2/5] regulator: da9055 change irq state to default
Message-ID: <20130118072324.GE4960@opensource.wolfsonmicro.com>
References: <1358486565.14373.10.camel@dhruva>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1358486565.14373.10.camel@dhruva>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 10:52:45AM +0530, Ashish Jangam wrote:
> This patch changes the irq state from high to the now default low
> state.
> 
> This patch is dependent on the DA9055 MFD.

Why is this change required and why is there a dependency here?

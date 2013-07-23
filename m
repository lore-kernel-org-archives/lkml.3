Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935176Ab3GWW5d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:57:33 -0400
Received: from filtteri6.pp.htv.fi ([213.243.153.189]:38695 "EHLO
	filtteri6.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934460Ab3GWW52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:57:28 -0400
Date: Wed, 24 Jul 2013 01:57:15 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that
 hasn't changed
Message-ID: <20130723225715.GD31864@blackmetal.musicnaut.iki.fi>
References: <1374383575-31493-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374383575-31493-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jul 21, 2013 at 01:12:55AM -0400, Paul Gortmaker wrote:
> Looking at the bigger picture, the need for this file has simply
> passed.  It was trying to detail required versions of userspace
> packages, in order to cater to hand-crafted systems.  But now the
> majority of users get their userspace all at once from some kind
> of distro, and we are probably a lot more serious about avoiding
> breaking userspace than we were a dozen years ago.

Is there any file describing the needed tools (and minimum versions) to
_build_ the kernel? I agree that trying to describe such for the run-time
userspace does not belong to the kernel tree, but the required/supported
versions of build tools should be still maybe documented...

A.

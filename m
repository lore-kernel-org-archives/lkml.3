Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab3GXAex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 20:34:53 -0400
Received: from filtteri2.pp.htv.fi ([213.243.153.185]:45992 "EHLO
	filtteri2.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758186Ab3GXAew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 20:34:52 -0400
Date: Wed, 24 Jul 2013 03:34:39 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: Rob Landley <rob@landley.net>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation/Changes: phase out Changes file that
 hasn't changed
Message-ID: <20130724003439.GE31864@blackmetal.musicnaut.iki.fi>
References: <20130723225715.GD31864@blackmetal.musicnaut.iki.fi>
 <1374621001.3031.1@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374621001.3031.1@driftwood>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jul 23, 2013 at 06:10:01PM -0500, Rob Landley wrote:
> On 07/23/2013 05:57:15 PM, Aaro Koskinen wrote:
> >Is there any file describing the needed tools (and minimum versions) to
> >_build_ the kernel? I agree that trying to describe such for the run-time
> >userspace does not belong to the kernel tree, but the required/supported
> >versions of build tools should be still maybe documented...
> 
> Documentation/changes _is_ the file that describes the kernel's
> build-time prerequisites.

So, in that case the file should not be deleted.

A.

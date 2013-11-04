Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab3KDLI5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 06:08:57 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:56991 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3KDLI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 06:08:56 -0500
Date: Mon, 4 Nov 2013 12:08:49 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: remove unused Kconfig parameters
Message-ID: <20131104110849.GA4117@osiris>
References: <1383558219-5223-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383558219-5223-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110411-8372-0000-0000-000007A89CA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 04, 2013 at 10:43:39AM +0100, Michael Opdenacker wrote:
> This removes the HAVE_MARCH_Z900_FEATURES and
> HAVE_MARCH_Z990_FEATURES Kconfig parameters,
> which were no longer used anywhere in the source code
> and Makefiles.
> 
> Actually, HAVE_MARCH_Z990_FEATURES is no longer used
> after removing HAVE_MARCH_Z900_FEATURES.
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Thanks for the patch. However each architecture generation is supposed to
have its own "HAVE_MARCH_*" config.
Even if its not used right now, it might create problems in the future
if they are only partially present.
So I'm not going to apply your patch.


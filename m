Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbaI0H5U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:57:20 -0400
Received: from e06smtp17.uk.ibm.com ([195.75.94.113]:41022 "EHLO
	e06smtp17.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbaI0H5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:57:06 -0400
Date: Sat, 27 Sep 2014 09:57:01 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: schwidefsky@de.ibm.com, linux390@de.ibm.com, linux-s390@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: remove unused Kconfig params
Message-ID: <20140927075701.GA6926@osiris>
References: <1411799130-17875-1-git-send-email-michael.opdenacker@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411799130-17875-1-git-send-email-michael.opdenacker@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092707-0542-0000-0000-000000F341D9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 27, 2014 at 08:25:30AM +0200, Michael Opdenacker wrote:
> Remove the below Kconfig parameters, which are no longer
> used anywhere in the source code and Makefiles:
> 
> HAVE_MARCH_Z900_FEATURES
> HAVE_MARCH_Z990_FEATURES
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

What I wrote you a year ago is still true:

https://lkml.org/lkml/2013/11/4/69

Thanks,
Heiko


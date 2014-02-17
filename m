Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929AbaBQIUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 03:20:42 -0500
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:39032 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750945AbaBQIUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 03:20:40 -0500
Date: Mon, 17 Feb 2014 09:20:35 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: remove HAVE_MARCH_Z9?0_FEATURES
Message-ID: <20140217082035.GA4651@osiris>
References: <1392570927.28866.12.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392570927.28866.12.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021708-8372-0000-0000-000008B06DFE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 16, 2014 at 06:15:27PM +0100, Paul Bolle wrote:
> The Kconfig symbols HAVE_MARCH_Z900_FEATURES and
> HAVE_MARCH_Z990_FEATURES were added in v3.5. They have never been used.
> Apparently they are not needed. They can safely be removed.
> 

No, I want to keep them, so there is a config symbol for each cpu generation
and we don't have to add the config symbols again, if we actually use them.
It's a question of completeness in this case, not if they are being used.

Thanks,
Heiko


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118AbbASMPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:15:37 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:33146 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444AbbASMPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:15:34 -0500
Date: Mon, 19 Jan 2015 13:15:28 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [linux-next] s390: Dump check for CONFIG_ZFCPDUMP
Message-ID: <20150119121528.GA5151@osiris>
References: <1421400905.15194.15.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421400905.15194.15.camel@x220>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011912-0021-0000-0000-00000297566D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 16, 2015 at 10:35:05AM +0100, Paul Bolle wrote:
> Commit 725908110a1f ("s390: add SMT support") added a check for
> CONFIG_ZFCPDUMP. But the Kconfig symbol ZFCPDUMP was removed in v3.16
> through commit bf28a5970de3 ("s390/dump: Remove CONFIG_ZFCPDUMP"). So
> this check will always evaluate to false. No one noticed probably
> because the code also checks for CONFIG_CRASH_DUMP which "also enables
> s390 zfcpdump".
> 
> Dump the unneeded check.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Applied, thanks.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863AbaG2Ofl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 10:35:41 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:45528 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753741AbaG2Ofj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 10:35:39 -0400
Date: Tue, 29 Jul 2014 16:35:32 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Ursula Braun <ubraun@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Frank Blaschka <blaschka@linux.vnet.ibm.com>,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        Ursula Braun <ursula.braun@de.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s390: net: ctcm_main.c: Cleaning up missing
 null-terminate in conjunction with strncpy
Message-ID: <20140729143532.GB4202@osiris>
References: <1406385234-3123-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1406639463.13705.9.camel@BR9GV9YG.de.ibm.com>
 <CAFo99gb2sSHVhDG0x6FzYi+YcKT7hQnu7qmUG=kaXyNaq4vKzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gb2sSHVhDG0x6FzYi+YcKT7hQnu7qmUG=kaXyNaq4vKzw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14072914-0342-0000-0000-00000096B19F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 03:19:47PM +0200, Rickard Strandqvist wrote:
> > It is guaranteed that the string ch->id always fits into CTCM_ID_SIZE.
> > What's in this case the benefit of replacing strncpy() by strlcpy()
> > here?
> 
> If it is really so! It can just as well replacing it with strcpy...

Or.. just leave the code alone.


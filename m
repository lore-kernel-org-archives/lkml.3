Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab3FJJYF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:24:05 -0400
Received: from e06smtp18.uk.ibm.com ([195.75.94.114]:36047 "EHLO
	e06smtp18.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab3FJJYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:24:02 -0400
Date: Mon, 10 Jun 2013 11:21:06 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Chen Gang <gang.chen@asianux.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Mike Frysinger <vapier@gentoo.org>,
        takata@linux-m32r.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Marc Gauthier <Marc.Gauthier@tensilica.com>
Subject: Re: [PATCH v2] arch: asm-generic: for atomic_set_mask() 1st param,
 use 'unsigned int' instead of 'unsigned long'
Message-ID: <20130610092106.GA4697@osiris>
References: <51B2E262.3030603@asianux.com>
 <CAErSpo5pg0EvJOR9nn3B0d+q0o6zsdwzM41AQx=AHfynRqX3hQ@mail.gmail.com>
 <51B4214E.6090007@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51B4214E.6090007@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061009-6892-0000-0000-0000056186D1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 02:31:42PM +0800, Chen Gang wrote:
> 
> atomic_set_mask() and atomic_clear_mask() are the pairs, so the related
> parameters' type need match with each other.
> 
> The type of 'addr->counter' is 'int', so use 'unsigned int' instead
> of 'unsigned long', and let atomic_set_mask() match atomic_clear_mask().
> 
> 
> For arch sub-system, currently, have 3 types of definition for them:
> 1st for 'int', 2nd for 'long', 3rd is conflict to use 'int' and 'long'.
> 
> At least, better to fix 3rd (conflict using 'int' and 'long').
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  arch/blackfin/include/asm/atomic.h |    4 ++--
>  arch/m32r/include/asm/atomic.h     |    8 ++++----
>  arch/s390/include/asm/atomic.h     |    4 ++--
>  include/asm-generic/atomic.h       |    2 +-
>  4 files changed, 9 insertions(+), 9 deletions(-)

For the s390 part:

Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>


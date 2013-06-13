Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3FMBUh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:20:37 -0400
Received: from intranet.asianux.com ([58.214.24.6]:53455 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756833Ab3FMBUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:20:36 -0400
X-Spam-Score: -100.8
Message-ID: <51B91E32.2040502@asianux.com>
Date: Thu, 13 Jun 2013 09:19:46 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Mike Frysinger <vapier@gentoo.org>,
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
References: <51B2E262.3030603@asianux.com> <CAErSpo5pg0EvJOR9nn3B0d+q0o6zsdwzM41AQx=AHfynRqX3hQ@mail.gmail.com> <51B4214E.6090007@asianux.com> <20130610092106.GA4697@osiris>
In-Reply-To: <20130610092106.GA4697@osiris>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 05:21 PM, Heiko Carstens wrote:
> On Sun, Jun 09, 2013 at 02:31:42PM +0800, Chen Gang wrote:
>> > 
>> > atomic_set_mask() and atomic_clear_mask() are the pairs, so the related
>> > parameters' type need match with each other.
>> > 
>> > The type of 'addr->counter' is 'int', so use 'unsigned int' instead
>> > of 'unsigned long', and let atomic_set_mask() match atomic_clear_mask().
>> > 
>> > 
>> > For arch sub-system, currently, have 3 types of definition for them:
>> > 1st for 'int', 2nd for 'long', 3rd is conflict to use 'int' and 'long'.
>> > 
>> > At least, better to fix 3rd (conflict using 'int' and 'long').
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/blackfin/include/asm/atomic.h |    4 ++--
>> >  arch/m32r/include/asm/atomic.h     |    8 ++++----
>> >  arch/s390/include/asm/atomic.h     |    4 ++--
>> >  include/asm-generic/atomic.h       |    2 +-
>> >  4 files changed, 9 insertions(+), 9 deletions(-)
> For the s390 part:
> 
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 

Thank you very much !!


-- 
Chen Gang

Asianux Corporation

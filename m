Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756969Ab3GEBMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 21:12:23 -0400
Received: from intranet.asianux.com ([58.214.24.6]:56219 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab3GEBMV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 21:12:21 -0400
X-Spam-Score: -100.8
Message-ID: <51D61D40.9050500@asianux.com>
Date: Fri, 05 Jul 2013 09:11:28 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org
CC: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mike Frysinger <vapier@gentoo.org>, takata@linux-m32r.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>,
        Marc Gauthier <Marc.Gauthier@tensilica.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2] arch: asm-generic: for atomic_set_mask() 1st param,
 use 'unsigned int' instead of 'unsigned long'
References: <51B2E262.3030603@asianux.com> <CAErSpo5pg0EvJOR9nn3B0d+q0o6zsdwzM41AQx=AHfynRqX3hQ@mail.gmail.com> <51B4214E.6090007@asianux.com> <20130610092106.GA4697@osiris> <51B91E32.2040502@asianux.com> <51CA4C0E.9050909@asianux.com>
In-Reply-To: <51CA4C0E.9050909@asianux.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Maintainers:

Please help check this patch whether OK, when you have time.

Thanks.

On 06/26/2013 10:03 AM, Chen Gang wrote:
> Hello Maintainers:
> 
> Firstly thank the s390 maintainers again for their 'Acked-by' (in my
> memory, s390 is the most important business mainframe machine)
> 
> Could another related maintainers give a glance for it, when you have time.
> 
> Thanks.
> 
> On 06/13/2013 09:19 AM, Chen Gang wrote:
>> On 06/10/2013 05:21 PM, Heiko Carstens wrote:
>>> On Sun, Jun 09, 2013 at 02:31:42PM +0800, Chen Gang wrote:
>>>>>
>>>>> atomic_set_mask() and atomic_clear_mask() are the pairs, so the related
>>>>> parameters' type need match with each other.
>>>>>
>>>>> The type of 'addr->counter' is 'int', so use 'unsigned int' instead
>>>>> of 'unsigned long', and let atomic_set_mask() match atomic_clear_mask().
>>>>>
>>>>>
>>>>> For arch sub-system, currently, have 3 types of definition for them:
>>>>> 1st for 'int', 2nd for 'long', 3rd is conflict to use 'int' and 'long'.
>>>>>
>>>>> At least, better to fix 3rd (conflict using 'int' and 'long').
>>>>>
>>>>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
>>>>> ---
>>>>>  arch/blackfin/include/asm/atomic.h |    4 ++--
>>>>>  arch/m32r/include/asm/atomic.h     |    8 ++++----
>>>>>  arch/s390/include/asm/atomic.h     |    4 ++--
>>>>>  include/asm-generic/atomic.h       |    2 +-
>>>>>  4 files changed, 9 insertions(+), 9 deletions(-)
>>> For the s390 part:
>>>
>>> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>>>
>>
>> Thank you very much !!
>>
>>
> 
> 


-- 
Chen Gang

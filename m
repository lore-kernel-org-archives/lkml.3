Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932353Ab3FMBsV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 21:48:21 -0400
Received: from intranet.asianux.com ([58.214.24.6]:50116 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932332Ab3FMBsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 21:48:16 -0400
X-Spam-Score: -100.8
Message-ID: <51B924AE.40103@asianux.com>
Date: Thu, 13 Jun 2013 09:47:26 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Mike Frysinger <vapier@gentoo.org>, takata@linux-m32r.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: asm-geniric: for atomic_set_mask() 1st param, use
 'unsigned int' instead of 'unsigned long'
References: <51B2E262.3030603@asianux.com> <CAErSpo5pg0EvJOR9nn3B0d+q0o6zsdwzM41AQx=AHfynRqX3hQ@mail.gmail.com> <51B3DFCF.1010509@asianux.com> <CAErSpo57_4SnE0_UwNvRc-M2+JvHmpiYTpQE2rAFUXuBEopvFA@mail.gmail.com>
In-Reply-To: <CAErSpo57_4SnE0_UwNvRc-M2+JvHmpiYTpQE2rAFUXuBEopvFA@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2013 01:00 AM, Bjorn Helgaas wrote:
> On Sat, Jun 8, 2013 at 7:52 PM, Chen Gang <gang.chen@asianux.com> wrote:
>> > On 06/09/2013 01:49 AM, Bjorn Helgaas wrote:
>>> >> s/geniric/generic/ in subject
>>> >>
>> >
>> > Could you provide more details information ?
> In your subject line, "geniric" is spelled incorrectly.  The correct
> spelling is "generic."
> 
> 

Thanks.

-- 
Chen Gang

Asianux Corporation

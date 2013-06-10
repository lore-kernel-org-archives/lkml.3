Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161Ab3FJRBQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:01:16 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:53723 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab3FJRBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:01:13 -0400
MIME-Version: 1.0
In-Reply-To: <51B3DFCF.1010509@asianux.com>
References: <51B2E262.3030603@asianux.com> <CAErSpo5pg0EvJOR9nn3B0d+q0o6zsdwzM41AQx=AHfynRqX3hQ@mail.gmail.com>
 <51B3DFCF.1010509@asianux.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 10 Jun 2013 11:00:53 -0600
Message-ID: <CAErSpo57_4SnE0_UwNvRc-M2+JvHmpiYTpQE2rAFUXuBEopvFA@mail.gmail.com>
Subject: Re: [PATCH] arch: asm-geniric: for atomic_set_mask() 1st param, use
 'unsigned int' instead of 'unsigned long'
To: Chen Gang <gang.chen@asianux.com>
Cc: Mike Frysinger <vapier@gentoo.org>, takata@linux-m32r.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Arnd Bergmann <arnd@arndb.de>, realmz paranoid <realmz6@gmail.com>,
        linux390@de.ibm.com,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-m32r@ml.linux-m32r.org, linux-m32r-ja@ml.linux-m32r.org,
        linux-s390@vger.kernel.org, Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 8, 2013 at 7:52 PM, Chen Gang <gang.chen@asianux.com> wrote:
> On 06/09/2013 01:49 AM, Bjorn Helgaas wrote:
>> s/geniric/generic/ in subject
>>
>
> Could you provide more details information ?

In your subject line, "geniric" is spelled incorrectly.  The correct
spelling is "generic."

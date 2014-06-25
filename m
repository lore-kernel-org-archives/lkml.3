Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353AbaFYO1c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 10:27:32 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47211 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873AbaFYO1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 10:27:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140625142043.GP23137@kvack.org>
References: <20140624154952.751713761@linuxfoundation.org>
	<20140625142043.GP23137@kvack.org>
Date: Wed, 25 Jun 2014 10:27:29 -0400
X-Google-Sender-Auth: V9-gXMit5YRc0kTEygWOjik5_Ac
Message-ID: <CA+5PVA7OPxScruo73jv8K_SvzyQ=22Z9MjVEN3F3yHuAWoXHjw@mail.gmail.com>
Subject: Re: [PATCH 3.15 00/61] 3.15.2-stable review
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:20 AM, Benjamin LaHaise <bcrl@kvack.org> wrote:
> Hi Greg,
>
> On Tue, Jun 24, 2014 at 11:50:43AM -0400, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.15.2 release.
>> There are 61 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>
> You'll probably want to include the fixes for CVE-2014-0206 -- these are
> edfbbf388f293d70bf4b7c0bc38774d05e6f711a and
> f8567a3845ac05bb28f3c1b478ef752762bd39ef .

FWIW, they should cherry-pick cleanly on top of 3.15.1 and 3.14.8.
I've not tried anything older yet.

josh

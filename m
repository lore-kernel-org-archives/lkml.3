Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbaFRDtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 23:49:04 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41344 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756370AbaFRDtC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 23:49:02 -0400
Message-ID: <53A10C21.8070101@zytor.com>
Date: Tue, 17 Jun 2014 20:48:49 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: Josh Boyer <jwboyer@fedoraproject.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: vdso_install target broken post-3.15
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com> <CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com> <CALCETrXG=752GrPhP8zKJUciiagCVRO0kenDOqL78eP73Y3ryA@mail.gmail.com> <5398749B.4090209@zytor.com> <CALCETrXMxn1-qqTkf271+=7F1Aiy7c=rNsnq9cRoB=e1k-Q3UQ@mail.gmail.com> <CALCETrUVudD++7i679xVW_NvvVUmHpUqdufjbguQciT5k5sguQ@mail.gmail.com>
In-Reply-To: <CALCETrUVudD++7i679xVW_NvvVUmHpUqdufjbguQciT5k5sguQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2014 08:45 PM, Andy Lutomirski wrote:
> On Tue, Jun 17, 2014 at 3:54 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>> Just a heads up: gdb can't debug the vdso on 3.16-rc1.  I filed a bug:
>>
>> https://sourceware.org/bugzilla/show_bug.cgi?id=17064
>>
>> We may need to extend the fake section header hack to all vdso
>> versions and stick the ELF notes in there.
> 
> I have a semi-working implementation of a workaround, bit it adds a
> fair amount of extra crud to the image, and it's pushing my
> configuration past a page boundary.  I suspect that, if we're willing
> to abuse the ELF format a bit more, I can get the overhead down,
> though.
> 
> Are we okay with regressing here until binutils gets fixed?
> 

Probably not... although I guess it depends just how bad it really is.

	-hpa



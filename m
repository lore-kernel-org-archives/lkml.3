Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965AbaFKPYW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 11:24:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47468 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932284AbaFKPYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 11:24:20 -0400
Message-ID: <53987499.2080704@zytor.com>
Date: Wed, 11 Jun 2014 08:24:09 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Josh Boyer <jwboyer@fedoraproject.org>
CC: Andy Lutomirski <luto@amacapital.net>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: vdso_install target broken post-3.15
References: <CA+5PVA4srNrj2xqMYH40N13rV+jC-PbLdyNpoURomTq48cJNBA@mail.gmail.com>	<CA+5PVA7gL6T2eXAy6G4hGJzhKZ_8KHd0qauKqzuHAP4oTJ97QA@mail.gmail.com>	<5398732E.2060900@zytor.com> <CA+5PVA4C4pvFyQyqiGLRpJqp=RF+3q7=aMs_KKnzS1=VU5ojsQ@mail.gmail.com>
In-Reply-To: <CA+5PVA4C4pvFyQyqiGLRpJqp=RF+3q7=aMs_KKnzS1=VU5ojsQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2014 08:20 AM, Josh Boyer wrote:
>>
>> Since when do we support "make" in a subdirectory?
> 
> Dunno.  Since when do we break existing make targets that worked fine?
> 
> Seriously, I'm just asking how this was build tested so I can try and
> duplicate that and then figure out how to fix the actual bug.
> 

Just building normally, from the top level.  The actual problem here is
that "make vdso_install" (unstripped vdso*.so files) doesn't work, which
is somewhat obscure (which is not to say unimportant - it isn't.)

	-hpa


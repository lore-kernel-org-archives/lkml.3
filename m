Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754262Ab3CKStL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 14:49:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44538 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686Ab3CKStJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 14:49:09 -0400
Message-ID: <513E2695.3080707@zytor.com>
Date: Mon, 11 Mar 2013 11:46:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>
CC: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, kdump: Set crashkernel_low automatically
References: <513D52BA.3070206@redhat.com> <1362977817-23297-1-git-send-email-yinghai@kernel.org> <20130311144853.GB8482@redhat.com> <20130311150256.GC8482@redhat.com> <CAE9FiQW1CHJ-j9aFgdtKEsgyZSTHTS1HzgMSGM8FnV7Ns3kUvw@mail.gmail.com> <20130311182655.GB12107@redhat.com>
In-Reply-To: <20130311182655.GB12107@redhat.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2013 11:26 AM, Vivek Goyal wrote:
>>
> Hi Yinghai,
> 
> In mutt your patches are showing as attachment instead of inline. Mutt
> thinks attachment is of type "application/octet-stream". Not sure if
> this is configuration issue on my part or something is going on your
> end.
> 
> I have few more concerns.
> 
> - Are we able to reserve 512MB memory now below 896MB. I remember so
>   far it was broken.
> 

What is the purpose of reserving that kind of memory below 896 MB?  If
you have a 32-bit system, it will likely be useless since you are
robbing the primary of most of lowmem, on a 64-bit system 896 MB is not
a magic value in any way...?

	-hpa


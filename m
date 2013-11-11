Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab3KKQDT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:03:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44512 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3KKQDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:03:08 -0500
Message-ID: <5280FF8E.8050801@zytor.com>
Date: Mon, 11 Nov 2013 08:02:22 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Vivek Goyal <vgoyal@redhat.com>, Andrew Morton <akpm@linux-foundation.org>
CC: Baoquan He <bhe@redhat.com>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        davej@fedoraproject.org, rmk+kernel@arm.linux.org.uk,
        chaowang@redhat.com, mwhitehe@redhat.com, kexec@lists.infradead.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Robin Holt <robinmholt@linux.com>, Robin Holt <robinmholt@gmail.com>
Subject: Re: [PATCH] x86: make reboot task only run on the appropriate processor
References: <1383642967-12595-1-git-send-email-bhe@redhat.com> <20131108151416.GA13068@redhat.com> <527D0D50.6010607@zytor.com> <20131111152948.GA11547@redhat.com> <469ce80c-c6a0-4238-aab5-9a4d8c562387@email.android.com> <20131111155711.GB11547@redhat.com>
In-Reply-To: <20131111155711.GB11547@redhat.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2013 07:57 AM, Vivek Goyal wrote:
> On Mon, Nov 11, 2013 at 07:39:18AM -0800, H. Peter Anvin wrote:
>> Yes, unless there is a better path for it since it is not x86-specific.  I am fine taking it, though.
> 
> Generally Andrew Morton routes kexec/kdump patches through his tree. Andrew,
> do you think it should go through your tree?
> 
> Thanks
> Vivek

If so, you can have my:

Acked-by: H. Peter Anvin <hpa@linux.intel.com>

	-hpa



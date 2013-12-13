Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab3LMIWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:22:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:21379 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab3LMIWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:22:49 -0500
Message-ID: <52AAC35D.6060604@oracle.com>
Date: Fri, 13 Dec 2013 09:20:45 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org>
In-Reply-To: <20131212190659.GG13547@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 08:06 PM, Theodore Ts'o wrote:
> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>> The idea is simple -- since different kernel versions are vulnerable to
>> different root exploits, hackers most likely try multiple exploits before
>> they actually succeed.
>
> Suppose we put put this into the mainstream kernel.  Wouldn't writers
> of root kit adapt by checking for the kernel version to avoid checking
> for exploits that are known not work?  So the question is whether the
> additional complexity in the kernel is going to be worth it, since
> once the attackers adapt, the benefits of trying to detect attacks for
> mitigated exploits will be minimal.

Yeah, you could probably avoid detection by being more careful. But I 
think it would be worth making it harder; I'd argue that the "additional 
complexity" in this case is minimal, since we are mostly talking about 
~1 line added to an error path for each critical vulnerability.


Vegard

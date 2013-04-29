Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab3D2NVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 09:21:41 -0400
Received: from ns.iliad.fr ([212.27.33.1]:53508 "EHLO ns.iliad.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757821Ab3D2NVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 09:21:36 -0400
Message-ID: <517E73DE.7050600@freebox.fr>
Date: Mon, 29 Apr 2013 15:21:34 +0200
From: Nicolas Schichan <nschichan@freebox.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Xi Wang <xi.wang@gmail.com>
CC: Daniel Borkmann <dborkman@redhat.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King <linux@arm.linux.org.uk>,
        Eric Dumazet <edumazet@google.com>, Will Drewry <wad@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mircea Gherzan <mgherzan@gmail.com>
Subject: Re: [RFC PATCH net-next 0/6] seccomp filter JIT
References: <1366962706-24204-1-git-send-email-xi.wang@gmail.com> <20130426112539.GA3736@osiris> <517A6915.2020208@redhat.com> <CAKU6vybdnpoM-szTrJRDVM2sqNPvAe3Tszg+tCuziKSOEXjJ1w@mail.gmail.com> <517E6505.6030005@freebox.fr>
In-Reply-To: <517E6505.6030005@freebox.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/29/2013 02:18 PM, Nicolas Schichan wrote:
> My solution also allows the seccomp jit code to be disabled while still
> allowing jit on socket filters (via a Kconfig option). This might be useful to
> some people.

Please disregard the above, I had missed the fact that the 
BPF_S_ANC_SECCOMP_LD_W case was embedded in an #ifdef CONFIG_SECCOMP_FILTER.

Regards,

-- 
Nicolas Schichan
Freebox SAS

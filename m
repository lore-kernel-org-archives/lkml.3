Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab3DZWar (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 18:30:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751239Ab3DZWap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 18:30:45 -0400
Message-ID: <517AFFFB.9090201@redhat.com>
Date: Sat, 27 Apr 2013 00:30:19 +0200
From: Daniel Borkmann <dborkman@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Xi Wang <xi.wang@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Schichan <nschichan@freebox.fr>,
        Will Drewry <wad@chromium.org>, Mircea Gherzan <mgherzan@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel.borkmann@tik.ee.ethz.ch>,
        netdev@vger.kernel.org
Subject: Re: [PATCH V3 2/3] ARM: net: bpf_jit: make code generation less dependent
 on struct sk_filter.
References: <1366824429-26652-1-git-send-email-nschichan@freebox.fr> <1366824429-26652-3-git-send-email-nschichan@freebox.fr> <3592414.M8kQZLCXlW@wuerfel> <20130426122601.10ec05fcb4860df1b0a5b409@linux-foundation.org> <517AD9E2.2090704@redhat.com> <20130426130948.cbfd2f6256afc0e3ee7abeed@linux-foundation.org> <517AF926.3020302@redhat.com> <CAKU6vyYOZ-24TSyLa8t6Oipib37fE1gtvM8nWj2TDzVw-tv0jA@mail.gmail.com>
In-Reply-To: <CAKU6vyYOZ-24TSyLa8t6Oipib37fE1gtvM8nWj2TDzVw-tv0jA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2013 12:18 AM, Xi Wang wrote:
> Thanks for CCing.  One way to clean up this would be to refactor the
> bpf jit interface as:
>
>    bpf_func_t bpf_jit_compile(struct sock_filter *filter, unsigned int flen);
>    void bpf_jit_free(bpf_func_t bpf_func);
>
> Then both packet and seccomp filters can share the unified interface.
> Also, we don't need seccomp_filter_get_len() and other helpers.
>
> Do you want me to rebase my patch against linux-next and see how that goes?

Sure, whatever works for you. Not sure if it will still make it though.

Also, as Eric already mentioned earlier, please do not top-post your mails!
I think one reminder should be sufficient for that. ;-)

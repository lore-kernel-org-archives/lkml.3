Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab3GOTOC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 15:14:02 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:60813 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754634Ab3GOTN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 15:13:59 -0400
Message-ID: <1373915638.2591.45.camel@x61.thuisdomein>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Mon, 15 Jul 2013 21:13:58 +0200
In-Reply-To: <20130715190311.GA3385@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
	 <20130715170244.GA29883@kroah.com>
	 <20130715172431.GA8034@phenom.dumpdata.com>
	 <CA+55aFx0rLqQUig9VHsfckRX650H=kq6hXH35m=yev17zfi0EA@mail.gmail.com>
	 <20130715180202.GB2433@phenom.dumpdata.com>
	 <1373912743.2591.34.camel@x61.thuisdomein>
	 <20130715190311.GA3385@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2013 19:13:59.0013 (UTC) FILETIME=[75643150:01CE818F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 15:03 -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Jul 15, 2013 at 08:25:43PM +0200, Paul Bolle wrote:
> > And you're now also taking Michael's patch, that triggered this
> > discussion, aren't you?
> 
> I believe there is a better way of doing this that I had enumerated
> in the thread (see "xen: remove unused Kconfig parameter"). That was to
> remove the CONFIG_XEN_PRIVILIGED and XEN_CONFIG_DOM0 and instead have an
> CONFIG_XEN_HARDWARE_DOMAIN and CONFIG_XEN_CONTROL_DOMAIN which reflect the
> reality a lot better.

But, whatever you choose to do in the future, that needn't stop you from
dropping XEN_PRIVILIGED_GUEST now. It's basically a trivial cleanup.


Paul Bolle


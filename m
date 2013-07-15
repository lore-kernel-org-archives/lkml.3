Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab3GOSZr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:25:47 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:65258 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753156Ab3GOSZp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:25:45 -0400
Message-ID: <1373912743.2591.34.camel@x61.thuisdomein>
Subject: Re: CONFIG_* used by user-space to figure out whether a feature is
 on/off
From: Paul Bolle <pebolle@tiscali.nl>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Mon, 15 Jul 2013 20:25:43 +0200
In-Reply-To: <20130715180202.GB2433@phenom.dumpdata.com>
References: <20130715154050.GA5941@phenom.dumpdata.com>
	 <20130715170244.GA29883@kroah.com>
	 <20130715172431.GA8034@phenom.dumpdata.com>
	 <CA+55aFx0rLqQUig9VHsfckRX650H=kq6hXH35m=yev17zfi0EA@mail.gmail.com>
	 <20130715180202.GB2433@phenom.dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jul 2013 18:25:44.0030 (UTC) FILETIME=[B7D8D7E0:01CE8188]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 14:02 -0400, Konrad Rzeszutek Wilk wrote:
> How about I make you proud and post a patch. See:
> 
>  http://article.gmane.org/gmane.comp.boot-loaders.grub.devel/20332 

And you're now also taking Michael's patch, that triggered this
discussion, aren't you?


Paul Bolle


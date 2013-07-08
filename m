Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753463Ab3GHXfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 19:35:38 -0400
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:61817 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752969Ab3GHXfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 19:35:37 -0400
Message-ID: <1373326534.1438.10.camel@x61.thuisdomein>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
From: Paul Bolle <pebolle@tiscali.nl>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Matt Wilson <msw@amazon.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        jeremy@goop.org, xen-devel@lists.xensource.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        tglx@linutronix.de
Date: Tue, 09 Jul 2013 01:35:34 +0200
In-Reply-To: <20130708205834.GA481@pd.tnic>
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
	 <20130708192854.GF4927@phenom.dumpdata.com>
	 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
	 <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Jul 2013 23:35:35.0371 (UTC) FILETIME=[D84219B0:01CE7C33]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-08 at 22:58 +0200, Borislav Petkov wrote:
> On Mon, Jul 08, 2013 at 01:29:40PM -0700, H. Peter Anvin wrote:
> > What. The. Fuck.
> 
> This is just marvellous: grub2 has a bunch of scripts in /etc/grub.d
> which rely on the presence of kernel config files in /boot or / and
> greps them in order to do the menu entries based on the built-in
> features it finds in them.

0) I've raised this issue a few months ago, but not on the LKML (see
http://thread.gmane.org/gmane.linux.kernel.virtualization/19126 ).

1) And I also asked whether "userspace [can] require the build system to
keep using some Kconfig symbol" (see
http://article.gmane.org/gmane.linux.kernel.virtualization/19129 ).
Peter and you clearly think userspace can't.

2) But anyhow, unless that grub2 configuration file has changed, this
Kconfig symbol can still be dropped, because grub2's check for it is
actually superfluous.


Paul Bolle


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297Ab3GJD6t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 23:58:49 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54287 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab3GJD6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 23:58:48 -0400
Message-ID: <51DCDB37.204@zytor.com>
Date: Tue, 09 Jul 2013 20:55:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sander Eikelenboom <linux@eikelenboom.it>
CC: Borislav Petkov <bp@alien8.de>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, jeremy@goop.org,
        xen-devel@lists.xensource.com, Jan Beulich <JBeulich@suse.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        x86@kernel.org, Paul Bolle <pebolle@tiscali.nl>,
        virtualization@lists.linux-foundation.org, mingo@redhat.com,
        Matt Wilson <msw@amazon.com>, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com> <20130708192854.GF4927@phenom.dumpdata.com> <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com> <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic> <1373326534.1438.10.camel@x61.thuisdomein> <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com> <51DBDAB802000078000E37C1@nat28.tlf.novell.com> <20130709144840.GF24897@phenom.dumpdata.com> <20130709150554.GA27579@pd.tnic> <1382658288.20130710003458@eikelenboom.it>
In-Reply-To: <1382658288.20130710003458@eikelenboom.it>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:34 PM, Sander Eikelenboom wrote:
> 
> Grub does this in it's update script to prevent adding a xen + kernel combination that has no chance of booting when dom0 support has not been configured in the kernel.
> That doesn't seem to be a unreasonable thought.
> 

Except it does it backwards.  The test it uses is sufficient but not
necessary.

	-hpa



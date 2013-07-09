Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab3GIOzJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 10:55:09 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:49536 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753864Ab3GIOzF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:12:1>);
	Tue, 9 Jul 2013 10:55:05 -0400
Message-Id: <51DC406202000078000E39B2@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 09 Jul 2013 15:54:58 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "Borislav Petkov" <bp@alien8.de>, "Matt Wilson" <msw@amazon.com>,
        "Michael Opdenacker" <michael.opdenacker@free-electrons.com>,
        <jeremy@goop.org>, <x86@kernel.org>, <tglx@linutronix.de>,
        <virtualization@lists.linux-foundation.org>,
        <xen-devel@lists.xensource.com>, <mingo@redhat.com>,
        "Paul Bolle" <pebolle@tiscali.nl>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH] xen: remove unused Kconfig parameter
References: <1373264904-27053-1-git-send-email-michael.opdenacker@free-electrons.com>
 <20130708192854.GF4927@phenom.dumpdata.com>
 <20130708193457.GA6926@u109add4315675089e695.ant.amazon.com>
 <51DB2134.9040909@zytor.com> <20130708205834.GA481@pd.tnic>
 <1373326534.1438.10.camel@x61.thuisdomein>
 <f5d6bd67-7464-4932-a7ca-6026fe534fc7@email.android.com>
 <51DBDAB802000078000E37C1@nat28.tlf.novell.com>
 <20130709144840.GF24897@phenom.dumpdata.com>
In-Reply-To: <20130709144840.GF24897@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 09.07.13 at 16:48, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> Dom0 has been both - but there is nothing wrong with seperating these
> two labels. And therein I was thinking that the 'hardware backend domain'
> should be the introduced. I am not good with names so the best option
> seems CONFIG_XEN_PRIVILIGED, but that sounds to be like 'controlling 
> domain'.
> 
> Any good ideas for names? CONFIG_XEN_HARDWARE_DOMAIN ? 
> CONFIG_XEN_PRIVILIGED_DOMAIN?

Following the naming in the hypervisor, CONFIG_XEN_HARDWARE_DOMAIN
and CONFIG_XEN_CONTROL_DOMAIN would seem reasonable to me.

Jan


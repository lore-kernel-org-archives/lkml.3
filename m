Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3J2QjY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:39:24 -0400
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:16873
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732Ab3J2QjW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:39:22 -0400
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dIc89bh1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h906i1155h192ch)
Date: Tue, 29 Oct 2013 09:39:13 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-serial@vger.kernel.org>
Subject: Re: [PATCH 1/3] tty: xuartps: Fix "may be used uninitialized" build
 warning
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
 <1382398861-21542-2-git-send-email-soren.brinkmann@xilinx.com>
 <20131029162252.GA21986@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20131029162252.GA21986@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Message-ID: <49d5e652-87b6-4e4c-8812-398bd2076d76@VA3EHSMHS008.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:22:52AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Oct 21, 2013 at 04:40:59PM -0700, Soren Brinkmann wrote:
> > Initialize varibles for which a 'may be used uninitalized' warning is
> > issued.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > The warning is actually a false positive. The variables are passed to a
> > function per reference. That function uses those variables to return
> > values, which then are used by the caller. Is there a way to
> > avoid the initialization and the build warning alltogether?
> > ---
> >  drivers/tty/serial/xilinx_uartps.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Please properly credit the kbuild robot who found these issues the next
> time...

Sorry for that. I'll do that next time.

	Thanks,
	Sören



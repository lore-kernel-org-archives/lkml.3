Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905AbaCGW7N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 17:59:13 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:48405
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753810AbaCGW7K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 17:59:10 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(z551biz98dIc89bh936eI1432I4015Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2fh95h839h93fhc61hd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h2438h2461h2487h24d7h2516h2545h255eh25f6h2605h906i1155h)
Date: Fri, 7 Mar 2014 14:59:04 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
CC: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-serial@vger.kernel.org>
Subject: Re: [PATCH RFC v2 08/11] tty: xuartps: Rename Kconfig symbols
References: <1394219614-3197-1-git-send-email-soren.brinkmann@xilinx.com>
 <1394219614-3197-9-git-send-email-soren.brinkmann@xilinx.com>
 <20140307213058.702ff194@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20140307213058.702ff194@alan.etchedpixels.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <a588bea6-d402-4a87-ada0-cdf13f13ba59@CH1EHSMHS033.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-03-07 at 09:30PM +0000, One Thousand Gnomes wrote:
> On Fri,  7 Mar 2014 11:13:31 -0800
> Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:
> 
> > Rename the config symbols for the Cadence UART to reflect the driver
> > rebranding:
> >   SERIAL_XILINX_PS_UART(_CONSOLE) -> SERIAL_CADENCE_UART(_CONSOLE)
> 
> This breaks all those setups people have with pre-packed .config files
> that have worked for a long time and now randomly need changing for this
> kernel.

And this will be dropped as well.

	Thanks,
	Sören



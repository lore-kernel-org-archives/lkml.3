Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3LPRDV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 12:03:21 -0500
Received: from mail-db8lp0189.outbound.messaging.microsoft.com ([213.199.154.189]:54302
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754680Ab3LPRDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 12:03:18 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371Ic89bh936eI1432Izz1f42h2148h208ch1ee6h1de0h1fdah2149h2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2fh95h839h93fhd24hf0ah119dh1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1fe8h1ff5h209eh2216h2336h906i1155h)
Date: Mon, 16 Dec 2013 09:03:02 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Guenter Roeck <linux@roeck-us.net>
CC: Mike Turquette <mturquette@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Hyun Kwon <hyunk@xilinx.com>
Subject: Re: [PATCH v5] clk: si570: Add a driver for SI570 oscillators
References: <1379806839-13762-1-git-send-email-soren.brinkmann@xilinx.com>
 <b625092b-682c-4072-85a6-9f9d7f378ec0@VA3EHSMHS043.ehs.local>
 <20131002231751.4343.81234@quantum>
 <52AC8857.8070504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <52AC8857.8070504@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <3bfd63dd-6bf1-4ae9-aaab-b913f9739c19@DB8EHSMHS015.ehs.local>
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenther, Mike,

On Sat, Dec 14, 2013 at 08:33:27AM -0800, Guenter Roeck wrote:
> On 10/02/2013 04:17 PM, Mike Turquette wrote:
> >Quoting Sören Brinkmann (2013-10-02 10:20:38)
> >>Hi Mike,
> >>
> >>could you please comment on this/apply it to clk-next?
> >
> >It looks good and is in the queue. Will show up in clk-next in a few
> >days.
> >
> Hi Mike,
> 
> trying again ... what happened with this driver ? Any reason for not pushing it after all ?

I've been waiting for it to appear in clk-next for a while too. I just
fetched the repo and it's there.
Thanks Guenter for following up and Mike for applying.

	Sören



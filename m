Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083Ab3LQH4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 02:56:04 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:37797
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054Ab3LQH4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 02:56:02 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -1
X-BigFish: VS-1(zz98dIzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzzz2dh87h2a8h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h209eh2216h22d0h2336h1151h1155h)
X-FB-DOMAIN-IP-MATCH: fail
Date: Tue, 17 Dec 2013 15:56:51 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: "Gupta, Pekon" <pekon@ti.com>
CC: Huang Shijie <b32955@freescale.com>,
        "mike@steroidmicros.com" <mike@steroidmicros.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "broonie@linaro.org" <broonie@linaro.org>,
        "angus.clark@st.com" <angus.clark@st.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "marex@denx.de" <marex@denx.de>,
        "Poddar, Sourav" <sourav.poddar@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-spi@vger.kernel.org" <linux-spi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "b44548@freescale.com" <b44548@freescale.com>,
        "b18965@freescale.com" <b18965@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v3 0/7] mtd: spi-nor: add a new framework for SPI NOR
Message-ID: <20131217075649.GL6691@S2101-09.ap.freescale.net>
References: <1387184330-14448-1-git-send-email-b32955@freescale.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA56ADC@DBDE04.ent.ti.com>
 <20131217040209.GA27091@shlinux2.ap.freescale.net>
 <20980858CB6D3A4BAE95CA194937D5E73EA56B3A@DBDE04.ent.ti.com>
 <20131217060731.GJ6691@S2101-09.ap.freescale.net>
 <20980858CB6D3A4BAE95CA194937D5E73EA56C5B@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EA56C5B@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: sigmatel.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 07:17:01AM +0000, Gupta, Pekon wrote:
> All I said was using company names in Headers or MODULE_AUTHOR of
> *generic frameworks*. A generic framework is maintained and updated
> by community at large. And over course of time other people contribute
> more than the author. So tagging a company name there would sound like
> _repeatedly_ giving credit to company or yourself, even if most of the
> original  code is changed now. Does that make sense ?

I could somehow buy in the argument of using person email over company
one in MODULE_AUTHOR(), but still not the one that do not use company
name in Headers.

In this case, Huang works for Freescale and Freescale pays him to do the
work, so Huang shares the authorship and Freescale shares the copyright.
There is nothing wrong adding Freescale copyright into the file header,
based on my understanding.  When other people make significant changes
and contributions to the file, they are welcomed to add more copyright
info on top of the existing ones.

I'm not a lawyer, and more than happy to be corrected if I'm wrong.

Shawn


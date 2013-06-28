Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab3F1Ksr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 06:48:47 -0400
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:13851
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755191Ab3F1Ksq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 06:48:46 -0400
X-Forefront-Antispam-Report: CIP:59.163.77.177;KIP:(null);UIP:(null);IPV:NLI;H:KCHJEXHC02.kpit.com;RD:59.163.77.177.static.vsnl.net.in;EFVD:NLI
X-SpamScore: -2
X-BigFish: VPS-2(zz98dI936eI1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h668h839h93fhd24hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e23hbe9i1155h)
Subject: Re: [patch v1 1/1]mfd: fix for DA9055 driver initialization
From: Ankur Raina <Ankur.Raina@kpitcummins.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <broonie@kernel.org>, "axel.lin@gmail.com" <axel.lin@gmail.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <david.chen@diasemi.com>
In-Reply-To: <20130627174111.GG20292@zurbaran>
References: <4B6D9C89CD8BA349A71B74CA32C47E5850DA82AF@KCHJEXMB02.kpit.com>
	 <20130627174111.GG20292@zurbaran>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Jun 2013 16:18:39 +0530
Message-ID: <1372416519.13538.25.camel@ankurr1-desktop>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.10.50.126]
X-OriginatorOrg: kpitcummins.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-06-27 at 19:41 +0200, Samuel Ortiz wrote:
> Hi Ankur,
> 
> On Thu, Jun 27, 2013 at 02:06:45PM +0000, Ankur Raina wrote:
> > This patch adds support for clearing events received while
> > powering up DA9055.
> Could you please explain what that fixes ?
While powering up DA9055,events are received of power sequencer.Events are also received on gpio's.
These events remain uncleared after boot up, due to which further event handling also fails.
This patch clears all the events received, during driver initialization, so that we have a clean state after boot up.

> 
> Cheers,
> Samuel.
> 



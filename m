Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbaD3Nqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 09:46:36 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:48462 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaD3Nqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 09:46:34 -0400
Date: Wed, 30 Apr 2014 15:46:28 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "mpa@pengutronix.de" <mpa@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv3 0/2] add DT endianness binding support
Message-ID: <20140430134628.GA6201@netboy>
References: <1398833029-29546-1-git-send-email-Li.Xiubo@freescale.com>
 <20140430071011.GA7312@netboy>
 <334a9f7420ca466b9011f0c0ae53abda@BY2PR03MB505.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <334a9f7420ca466b9011f0c0ae53abda@BY2PR03MB505.namprd03.prod.outlook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 07:14:08AM +0000, Li.Xiubo@freescale.com wrote:
> 
> > Subject: Re: [PATCHv3 0/2] add DT endianness binding support
> > 
> > Shouldn't this go to the arm list and rmk for review, too?
> > 
> 
> Well, yes, I forgot it.
> 
> Should I resend them ?

What I meant was, you should put

	<linux-arm-kernel@lists.infradead.org>

and

	"Russell King <linux@arm.linux.org.uk>"

onto CC.

Thanks,
Richard

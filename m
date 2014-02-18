Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530AbaBRVcp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 16:32:45 -0500
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:8123 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751419AbaBRVcn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 16:32:43 -0500
Date: Tue, 18 Feb 2014 13:34:29 -0800
From: Courtney Cavin <courtney.cavin@sonymobile.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Peter Chen <Peter.Chen@freescale.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] usb: chipidea: msm: Add device tree support
Message-ID: <20140218213428.GM1706@sonymobile.com>
References: <1392729681-21022-1-git-send-email-iivanov@mm-sol.com>
 <1392729681-21022-3-git-send-email-iivanov@mm-sol.com>
 <53039E2E.2030503@cogentembedded.com>
 <1392743648.17130.17.camel@iivanov-dev>
 <5303A71B.7060208@cogentembedded.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5303A71B.7060208@cogentembedded.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 07:31:55PM +0100, Sergei Shtylyov wrote:
> On 02/18/2014 08:14 PM, Ivan T. Ivanov wrote:
> 
> >>> From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> 
> >>> Allows controller to be specified via device tree.
> >>> Pass PHY phandle specified in DT to core driver.
> 
> >>> Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> >>> ---
> >>>    drivers/usb/chipidea/ci_hdrc_msm.c |   23 ++++++++++++++++++++++-
> >>>    1 file changed, 22 insertions(+), 1 deletion(-)
> 
> >>      You also need to describe the binding you're creating in
> >> Documentation/devicetree/bindings/usb/<file>.txt.
> 
> > Did you check "[PATCH v2 1/3]"?
> 
>     Did you send it to 'linux-usb'? I just didn't get the patch.
> (Typically, the bindings are described in the same patch the DT support is 
> added to the driver bu YMMV, of course.)

Although I would personally agree that this is the most logical method,
it would appear that the DT guys disagree with us [1].  Lately, they
seem to have either given up or are otherwise preoccupied, so perhaps
you can still slip a few patches by them. ;)

-Courtney

[1] https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/submitting-patches.txt

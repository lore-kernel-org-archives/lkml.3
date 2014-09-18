Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932479AbaIRRve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 13:51:34 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:12805 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932117AbaIRRvd convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 13:51:33 -0400
Date: Thu, 18 Sep 2014 10:51:40 -0700
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Tim Bird <tim.bird@sonymobile.com>
CC: Kumar Gala <galak@codeaurora.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arnd.bergmann@linaro.org" <arnd.bergmann@linaro.org>
Subject: Re: [PATCH] ARM: dts: Add initial DTS file for Sony Xperia Z1 phone
Message-ID: <20140918175139.GK10179@sonymobile.com>
References: <5418C1D2.4000303@sonymobile.com>
 <27E278AA-EBC0-4368-B75C-DCB2DD906612@codeaurora.org>
 <5418C471.9000807@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <5418C471.9000807@sonymobile.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 16 Sep 16:14 PDT 2014, Tim Bird wrote:

> 
> 
> On 09/16/2014 04:08 PM, Kumar Gala wrote:
> > 
> > On Sep 16, 2014, at 4:03 PM, Tim Bird <tim.bird@sonymobile.com> wrote:
[..]
> > 
> >> +	qcom,msm-id = <126 8 0>, <185 8 0>, <186 8 0>;
> > 
> > We don’t have qcom,msm-id upstream at this time.
> Do I just leave this out, then?

Both our tool to generate boot.img [1] and the Qualcomm equivalent require
these to be there.

Last time I tried to concatenate the dtb to zImage and using the Google
mkbootimg the bootloader refused to load the result. But please give it a test
and maybe we can postpone adding this definition. Otherwise we need to add a
definition - covering both the 8974 and 8974ab format.

[1] https://github.com/sonyxperiadev/mkqcdtbootimg

Regards,
Bjorn

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372AbaKLNsK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 08:48:10 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:46980 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbaKLNsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 08:48:07 -0500
Date: Wed, 12 Nov 2014 13:48:01 +0000
From: Peter Griffin <peter.griffin@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        srinivas.kandagatla@gmail.com, maxime.coquelin@st.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH 12/13] ARM: STi: DT: STiH410: Add STiH410 SoC clock
 support.
Message-ID: <20141112134801.GB20187@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415361475-6218-1-git-send-email-peter.griffin@linaro.org>
 <1415361475-6218-13-git-send-email-peter.griffin@linaro.org>
 <88469624.TsXJ3Gpfe2@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88469624.TsXJ3Gpfe2@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Thanks for reviewing.

> On Friday 07 November 2014 11:57:54 Peter Griffin wrote:
> > +
> > +       soc {
> > +
> > +               ohci0: usb@9a03c00 {
> > +                       status = "okay";
> > +               };
> > +
> > +               ehci0: usb@9a03e00 {
> > +                       status = "okay";
> > +               };
> > +
> > +               ohci1: usb@9a83c00 {
> > +                       status = "okay";
> > +               };
> > +
> > +               ehci1: usb@9a83e00 {
> > +                       status = "okay";
> > +               };
> > +       };
> > +};
> > 
> 
> These seem to refer to an existing device in the base dtsi file. Just put the label
> in the shared file and remove the exact names here. Alternatively, drop the labels
> you don't use.

Based on Maximes feedback in V2 I've created a seperate stih410.dtsi file
which has the extra ehci / ohci device nodes in it. This means they don't need to be
enabled in the board file any more.

regards,

Peter.

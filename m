Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaKHT0E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 14:26:04 -0500
Received: from mout.kundenserver.de ([212.227.17.13]:49227 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082AbaKHT0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 14:26:01 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org, frowand.list@gmail.com
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] tty: serial: msm_serial: Use DT aliases
Date: Sat, 08 Nov 2014 20:25:22 +0100
Message-ID: <1630864.S0zQWJED9T@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <545D3B31.3030309@gmail.com>
References: <1414024381-12204-1-git-send-email-sboyd@codeaurora.org> <2747100.M77UGx4AmB@wuerfel> <545D3B31.3030309@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:O/tkSCZLzhCntyBdpcACQ1MaYa91/wtAI68TpveOrh3
 PA5cSs7o3DEiCoVoOM3CQtPiweedNqOEbkgb9T2qSVvLHe9sGx
 DlExIWzcBf5a/hZ/ZcJBzX47i2PIAawXQ4gxWesvlq1qJLcok2
 QngnSX2Xtj8e6rri4C2ykPyf7lwRwKd/twKfW0qmF6OFs6xwKV
 SZbFD1Kd41YovuhHX7ssK/35KngVIlwApDNM647xsxoBdd4wvn
 x95jCwp1Anz3OdzX8fWftAtmN7LyY7AUtq/XeZxMCSNtebyZlK
 PzYAXDKDWew5RkLzWmx31WwSI2FS0HmAbF5lnUE+qUvKlZuzZJ
 ZKfjzzhDm9xVdpjOSOX8=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 07 November 2014 13:35:45 Frank Rowand wrote:
> On 11/7/2014 1:47 AM, Arnd Bergmann wrote:
> > On Thursday 06 November 2014 22:42:47 Frank Rowand wrote:
> >> This same change is also needed in:
> >>
> >>   qcom-ipq8064.dtsi
> >>   qcom-msm8960.dtsi
> >>   qcom-apq8084.dtsi
> >>   qcom-apq8064.dtsi
> >>   qcom-msm8660.dtsi
> >>
> >> but I did not want to just blindly apply those changes without testing.
> >>
> > 
> > Is there only one uart on each of these?
> > 
> > If not, it would be better to put the aliases in the board specific file,
> > pointing to whichever ports are in use, in the order that makes sense
> > for that board.
> 
> Good point, thanks for bringing it up.
> 
> Your comment made me verify that the board dts files can override the
> aliases from the included .dtsi.  So not a problem to have a default
> set of aliases in the .dtsi files.

I would think it's better to keep them in the per-board file out of
principle though.
	
	Arnd

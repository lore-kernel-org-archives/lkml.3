Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab3ARPMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:12:21 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:50223 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898Ab3ARPMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:12:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: Re: [PATCH v2 00/76] Synopsys ARC Linux kernel Port
Date: Fri, 18 Jan 2013 15:12:14 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1358511930-7424-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301181512.14441.arnd@arndb.de>
X-Provags-ID: V02:K0:2Q3De1dN4czzuyZt4It6kN+1ocGc6q2U0vUAjVXZRXe
 kUIa992uWOxTKMOTuV6E0cXToWJSVP0qsSeilBK0dhD1QIrhAf
 FRkrZ9BYozwx8W9qxjuGPC0DQiss7X5E9mfACQL4Euj5ds8aXX
 9/p69ixNJQbq2gpfZI61GT105dKKLwPyprXQJi92u0+Gt5Iyx1
 qJ0PD9g6GEHFLi7eM/Y+u2XFqCymFURdaOmqOhXddiG20786Jp
 nyWplalRrpbHfBZ4rJPEsKtA9vobzMB3o2ChUYnSqVBhSqfBg+
 K09HfrBXYKskODxMq3BSlnbDBYx+PjxxtpcGwqpUONeSUcVtiw
 ahM37x7POBELo6L8PUQk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 January 2013, Vineet Gupta wrote:
> This patchset based off-of 3.8-rc4, adds the Linux kernel port to ARC700
> processor family (750D and 770D) from Synopsys. I would be greatful for
> further review and feedback.
> 
> Salient points about v2 patchset
> -------------------------------
> * All of the feedback from v1 RFC patchseries has been addressed.
> 
> * Some of the major fixes for v1 review comments such as Device Tree support,
>   multi-platform-image and syscall-restart issues, have not been squashed
>   into relevent patches, but instead have been applied as slap-on patches
>   on orig ones. This is merely to build up some revision history into the
>   final-upstream-merged version. If people think it's too ugly, I can do
>   the chop-n-dice-n-squash, but my preference would be the style we have now.
> 
> * Unlike RFC v1 series (split into 2 part) this one includes the complete port
>   (still the minimal kernel at halfway checkpoint, builds/runs fine).
>   This combined with prev point, make the full patchset a touch large, for
>   which I appologize in advance.
> 
> * The entire series however is also available at
>   git://github.com/foss-for-synopsys-dwc-arc-processors/linux.git arc-3.8-lkml-v2
> 

Hi Vineet,

I've looked at the entire series again now, and it looks very good
overall, I only had comments for tiny issues. With 76 patches in the
series, I doubt that anybody is going to look through all of them
again though. Are the patches already part of Linux-next? If not,
I would recommend getting them in there as a preparation for merging
in 3.9.

I would also recommend to only send incremental patches after that,
as well as new versions of some of the patches if you decide to
replace them based on comments you get.

	Arnd

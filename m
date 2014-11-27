Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070AbaK0LYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 06:24:21 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53598 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329AbaK0LYS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 06:24:18 -0500
Date: Thu, 27 Nov 2014 11:24:13 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Pankaj Dubey <pankaj.dubey@samsung.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [v3, 1/2] arm64: Create link to include/dt-bindings to enable C
 preprocessor use.
Message-ID: <20141127112413.GL828@e106497-lin.cambridge.arm.com>
References: <1415727131-4572-2-git-send-email-Liviu.Dudau@arm.com>
 <5476E215.5020405@samsung.com>
MIME-Version: 1.0
In-Reply-To: <5476E215.5020405@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 27 Nov 2014 11:24:14.0684 (UTC) FILETIME=[ACC3E1C0:01D00A34]
X-MC-Unique: 114112711241604701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 27, 2014 at 08:34:29AM +0000, Pankaj Dubey wrote:
> Hi Liviu,
> 
> On Tuesday 11 November 2014 11:02 PM, Liviu Dudau wrote:
> > DT files used in the compilation phase can be preprocessed by the C
> > preprocessor. This requires an include/dt-bindings directory to be
> > present in the arch/arm64/boot/dts directory.
> >
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> >
> 
> Same change already has been posted as part of adding Exynos7 SoC 
> support, as Exynos7 patches have been accepted in Kukjin's tree, I think 
> following patch [1] as part of Exynos7 series [2] can also be taken.
> 
> 1: http://www.spinics.net/lists/devicetree/msg56552.html
> 2: http://www.spinics.net/lists/devicetree/msg56551.html

Hi Pankaj,

I don't know how Olof and Arnd are going to handle this, but I believe
Arnd has already merged my patchset into the arm-soc tree.

Best regards,
Liviu

> 
> Thanks,
> Pankaj Dubey
> 
> > ---
> > arch/arm64/boot/dts/include/dt-bindings | 1 +
> >   1 file changed, 1 insertion(+)
> >   create mode 120000 arch/arm64/boot/dts/include/dt-bindings
> >
> > \ No newline at end of file
> >
> > diff --git a/arch/arm64/boot/dts/include/dt-bindings b/arch/arm64/boot/dts/include/dt-bindings
> > new file mode 120000
> > index 0000000..08c00e4
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/include/dt-bindings
> > @@ -0,0 +1 @@
> > +../../../../../include/dt-bindings
> >
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯


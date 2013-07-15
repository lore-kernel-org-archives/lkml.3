Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3GONgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 09:36:50 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:62726 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756552Ab3GONgt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 09:36:49 -0400
Message-ID: <1373895406.7353.99.camel@marge.simpson.net>
Subject: Re: 3.10.0: Full dynticks = high load
From: Mike Galbraith <bitbucket@online.de>
To: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>
Date: Mon, 15 Jul 2013 15:36:46 +0200
In-Reply-To: <ks0s36$ntc$1@ger.gmane.org>
References: <krlv29$jbp$1@ger.gmane.org>
	 <20130712065227.GC1985@fancy-poultry.org> <ks0s36$ntc$1@ger.gmane.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
X-Provags-ID: V02:K0:kYKBAvCTL+hAnsXsARiQ+9NbImQFcYfeB6Wpm4oKOah
 RmGz3g/RN3wsN9EZA1NzXVKvhJHXySliShM89ATv1yRbHctVoa
 TbD6ETshGZ8GGsQBLMpq5TwGf81TwkF9/kRPNz1748IIVPoiAW
 AFDR+RGluDSca5BvaLnpKfY05dD02tyVUGaOCF9VicJlbi+X2a
 EiizEajMWEjEMG6raEAjc/bVCW2EOGpqzDQF2LGYFA+ttMA4xm
 Hd1IZlzJDt/DKmGtBonM6HJrHz/tIawWmw+UYRB/jz0HB+W7rA
 jCJEc4h4mGMoKhF6kGudQshgwa9skW4Lj4nkVHnFL9T39QY+Lb
 CxNqBuZaxPxNty1DPewSx0B0XKJxRcoUGOixM4M9B/Aa/LTHZE
 pnXkP20IsZkLw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(add cc)

On Mon, 2013-07-15 at 10:05 -0300, Dâniel Fraga wrote: 
> On Fri, 12 Jul 2013 08:52:27 +0200
> Heinz Diehl <htd@fancy-poultry.org> wrote:
> 
> > This describes exactly what I have encountered, and "tickless idle"
> > fixed it for me, too. So I'll second that.
> 
> 	Thanks for the confirmation. I hope Ingo Molnar fixes it.
> 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162972Ab3DEUuq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 16:50:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60670 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162957Ab3DEUun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 16:50:43 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Subject: Re: [PATCH v2 2/9] arm: mvebu: Align the internal registers virtual base to support LPAE
Date: Fri, 5 Apr 2013 22:50:28 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Nicolas Pitre <nico@fluxnic.net>,
        Lior Amsalem <alior@marvell.com>, Maen Suleiman <maen@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Shadi Ammouri <shadi@marvell.com>,
        "Eran Ben-Avi" <benavi@marvell.com>,
        Yehuda Yitschak <yehuday@marvell.com>,
        Nadav Haklai <nadavh@marvell.com>, Ike Pan <ike.pan@canonical.com>,
        Chris Van Hoof <vanhoof@canonical.com>,
        Dan Frazier <dann.frazier@canonical.com>,
        Leif Lindholm <leif.lindholm@arm.com>, Jon Masters <jcm@redhat.com>,
        David Marlin <dmarlin@redhat.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
References: <1365193444-13441-1-git-send-email-gregory.clement@free-electrons.com> <1365193444-13441-3-git-send-email-gregory.clement@free-electrons.com>
In-Reply-To: <1365193444-13441-3-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304052250.28641.arnd@arndb.de>
X-Provags-ID: V02:K0:4N9ZxWec/YhrPPkNvpx2nVgITkDGhmNfYdx3ra9GpE5
 8HoCaLGT4daUjU7KyXJi+lwoizu8ObXfRJUfLaAoZXf7geZwAk
 5wIhEzprS5BbtWvZGcHPHKRcTPnIxMGEUPWHwA4bZUN3q9nPIs
 Dy0nfbVDGvfMVKyXSsjv65bzpwdHP1crxrPy2yRz/cVHhpp65b
 3tByZAIG76K6zPsBMUISWW4N7rURIyAFwdWL76hsZDhK1Ylorc
 ob6gwZ3hFOy6Wu3EBEnwrj7DwYFzciVlGHjiGE0mxfs9LtXoH6
 hyo5IS+LAtuLBSwEqz122X0e3xcdCZqK6tYh+81yOp6TjhTj6U
 6qDpMwZ+vOXDC2LutZdA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 April 2013, Gregory CLEMENT wrote:
> From: Lior Amsalem <alior@marvell.com>
> 
> In order to be able to support he LPAE, the internal registers virtual
> base must be aligned to 2MB.
> 
> Signed-off-by: Lior Amsalem <alior@marvell.com>
> Signed-off-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

This is a surprising limitation. Can you extend the above text to go into more
detail where that alignment requirement comes from?

	Arnd

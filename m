Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaKJTKH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 14:10:07 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:61736 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431AbaKJTKF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 14:10:05 -0500
Date: Mon, 10 Nov 2014 20:12:54 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] ASoC: Remove 'const' from the device_node
 pointers
Message-ID: <20141110201254.65674552@armhf>
In-Reply-To: <20141110190332.GG3815@sirena.org.uk>
References: <cover.1415562021.git.moinejf@free.fr>
	<d5d74f6993e9f2392008a27a2938c58d47dc8062.1415562021.git.moinejf@free.fr>
	<20141110190332.GG3815@sirena.org.uk>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014 19:03:32 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Sun, Nov 09, 2014 at 08:33:45PM +0100, Jean-Francois Moine wrote:
> > From Russell King:
> > of_node_put() modifies the struct device_node contents.  Therefore,
> > of_node_put() definitely not treating the data pointed to as read-only,
> > and therefore it is completely inappropriate for it to be marked "const".
> 
> Did Russell write this patch (in which case it's missing a signoff and
> his e-mail address above) or are you trying to say "Russell King
> said..."?

Sorry, that was "Russell said ...".
Do you want I resubmit the patch?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

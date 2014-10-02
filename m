Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108AbaJBR7r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 13:59:47 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:19160 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066AbaJBR7p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 13:59:45 -0400
Date: Thu, 2 Oct 2014 19:59:51 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mark Brown <broonie@kernel.org>, Dave Airlie <airlied@gmail.com>,
        Andrew Jackson <Andrew.Jackson@arm.com>, Jyri Sarha <jsarha@ti.com>,
        alsa-devel@alsa-project.org, devicetree@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] drm/i2c:tda998x: Use the HDMI audio CODEC
Message-ID: <20141002195951.23dbc47d@armhf>
In-Reply-To: <20141001142340.GR5182@n2100.arm.linux.org.uk>
References: <cover.1411547014.git.moinejf@free.fr>
	<4b3d35a14461ed164956b7f5aa77b29170bc393d.1411547014.git.moinejf@free.fr>
	<20141001142340.GR5182@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Oct 2014 15:23:41 +0100
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> I would prefer this structure to stay here, as code above this point should
> have no business knowing how these are packaged together.  I would suggest
> either:
> 
> - moving the audio codec code below this point, or
> - storing struct tda998x_priv in the device private pointer, and
>   converting it to struct tda998x_priv2 via container_of() where
>   necessary below this point.

The second option seems easier for use as a slave encoder.

Thanks for all your remarks. I will send an other version.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/

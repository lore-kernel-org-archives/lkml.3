Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaCWKSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 06:18:46 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59566 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751288AbaCWKSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 06:18:44 -0400
Date: Sun, 23 Mar 2014 11:19:03 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] drm/i2c: tda998x: Change the compatible strings
Message-ID: <20140323111903.51c73c82@armhf>
In-Reply-To: <532C40B0.3000805@gmail.com>
References: <20140321115541.01cbbb06@armhf>
	<532C40B0.3000805@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014 14:37:52 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> >   Required properties;
> > -  - compatible: must be "nxp,tda998x"
> > +  - compatible: may be "nxp,tda9989", "nxp,tda19988" or "nxp,tda19989"  
> 
> There is a "DT is ABI" policy and although there is no mainline Linux
> user of current compatible, the correct way would be to deprecate
> "nxp,tda998x" and introduce new compatibles.

Pratically, what is this way?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
